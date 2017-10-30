class Hive < Formula
  desc "Hadoop-based data summarization, query, and analysis"
  homepage "https://hive.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=hive/hive-2.1.1/apache-hive-2.1.1-bin.tar.gz"
  sha256 "c945dfc39f6489a098507fffa8fe78d8bd41de64887439b024c163ba1d958edc"

  bottle :unneeded

  depends_on :java => "1.7+"
  depends_on "hadoop"

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
