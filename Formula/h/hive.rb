class Hive < Formula
  desc "Hadoop-based data summarization, query, and analysis"
  homepage "https://hive.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=hive/hive-4.1.0/apache-hive-4.1.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/hive/hive-4.1.0/apache-hive-4.1.0-bin.tar.gz"
  sha256 "9d160af85f0f44ea7e0ccaf0a8c876e36ac35abfd9f8c506504a11e6daaff9aa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "02d59498559e50e24ee6eee1e89cd108459de862499217510b51b34a61e1b41f"
  end

  depends_on "hadoop"
  depends_on "openjdk@17"

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
        JAVA_HOME:   Formula["openjdk@17"].opt_prefix,
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
