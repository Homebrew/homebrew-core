class Hive < Formula
  desc "Hadoop-based data summarization, query, and analysis"
  homepage "https://hive.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=hive/hive-4.2.1/apache-hive-4.2.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist/hive/hive-4.2.1/apache-hive-4.2.1-bin.tar.gz"
  sha256 "525c2d8b8ba28b808df361a8277d2af655a257d063ea2c9799790009b843a245"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c0aa6492035555c2d378c5cf93bc5aab63f8d38b99b49cd2fe2ce8c2fa411c19"
  end

  depends_on "hadoop"
  depends_on "openjdk@21"

  def install
    libexec.install %w[bin conf examples hcatalog lib scripts]

    # Hadoop currently supplies a newer version
    # and two versions on the classpath causes problems
    rm libexec/"lib/guava-22.0.jar"
    guava = (formula_opt_libexec("hadoop")/"share/hadoop/common/lib").glob("guava-*-jre.jar")
    ln_s guava.first, libexec/"lib"

    (libexec/"bin").each_child do |file|
      next if file.directory?

      (bin/file.basename).write_env_script file,
        JAVA_HOME:   formula_opt_prefix("openjdk@21"),
        HADOOP_HOME: "${HADOOP_HOME:-#{formula_opt_libexec("hadoop")}}",
        HIVE_HOME:   libexec
    end
  end

  def caveats
    <<~EOS
      If you want to use HCatalog with Pig, set $HCAT_HOME in your profile:
        export HCAT_HOME=#{opt_libexec}/hcatalog
    EOS
  end

  test do
    system bin/"schematool", "-initSchema", "-dbType", "derby"
    assert_match "123", shell_output("#{bin}/beeline -u jdbc:hive2:// -e 'SELECT 123'")
  end
end
