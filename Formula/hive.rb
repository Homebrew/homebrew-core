class Hive < Formula
  desc "Hadoop-based data summarization, query, and analysis"
  homepage "https://hive.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=hive/hive-3.1.0/apache-hive-3.1.0-bin.tar.gz"
  sha256 "f90b5988d4d81dafa97fa3059cfbb89ac6c8c1015b34b20f1e72902ddbb9927e"

  bottle :unneeded

  depends_on "hadoop"
  depends_on :java => "1.7+"

  def install
    rm_f Dir["bin/*.cmd", "bin/ext/*.cmd", "bin/ext/util/*.cmd"]
    libexec.install %w[bin conf examples hcatalog lib scripts]

    Pathname.glob("#{libexec}/bin/*") do |file|
      next if file.directory?
      (bin/file.basename).write_env_script file,
        Language::Java.java_home_env("1.7+").merge(:HIVE_HOME => libexec)
    end
  end

  def caveats; <<~EOS
    Hadoop must be in your path for hive executable to work.

    If you want to use HCatalog with Pig, set $HCAT_HOME in your profile:
      export HCAT_HOME=#{opt_libexec}/hcatalog
  EOS
  end

  test do
    system bin/"schematool", "-initSchema", "-dbType", "derby"
    assert_match "Hive #{version}", shell_output("#{bin}/hive --version")
  end
end
