class Hive < Formula
  desc "Hadoop-based data summarization, query, and analysis"
  homepage "https://hive.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=hive/hive-4.0.1/apache-hive-4.0.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist/hive/hive-4.0.1/apache-hive-4.0.1-bin.tar.gz"
  sha256 "2bf988a1ed17437b1103e367939c25a13f64d36cf6d1c3bef8c3f319f0067619"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "967f1273e5e14b787fb79b46fc2a8affb1cb09db6c0a6c7691aeca05343e3a96"
  end

  depends_on "hadoop"

  # hive requires Java 8.
  # Java 11 support ticket: https://issues.apache.org/jira/browse/HIVE-22415
  # Java 17 support ticket: https://issues.apache.org/jira/browse/HIVE-26473
  depends_on "openjdk@8"

  def install
    libexec.install %w[bin conf examples hcatalog lib scripts]

    # Hadoop currently supplies a newer version
    # and two versions on the classpath causes problems
    rm libexec/"lib/guava-22.0.jar"
    guava = (Formula["hadoop"].opt_libexec/"share/hadoop/common/lib").glob("guava-*-jre.jar")
    ln_s guava.first, libexec/"lib"

    (libexec/"bin").each_child do |file|
      next if file.directory?

      (bin/file.basename).write_env_script file,
        JAVA_HOME:   Formula["openjdk@8"].opt_prefix,
        HADOOP_HOME: "${HADOOP_HOME:-#{Formula["hadoop"].opt_libexec}}",
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
