class Hive < Formula
  desc "Hadoop-based data summarization, query, and analysis"
  homepage "https://hive.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=hive/hive-2.0.0/apache-hive-2.0.0-bin.tar.gz"
  sha256 "e854798954f48bdbc40235b1367287218464b62376d29dfcd2a328a0e7a184e6"

  bottle :unneeded

  depends_on "hadoop"
  depends_on :java

  def install
    rm_f Dir["bin/*.cmd", "bin/ext/*.cmd", "bin/ext/util/*.cmd"]
    libexec.install %w[bin conf examples hcatalog lib scripts]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  def caveats; <<-EOS.undent
    Hadoop must be in your path for hive executable to work.
    After installation, set $HIVE_HOME in your profile:
      export HIVE_HOME=#{libexec}

    If you want to use HCatalog with Pig, set $HCAT_HOME in your profile:
      export HCAT_HOME=#{libexec}/hcatalog

    You may need to set JAVA_HOME:
      export JAVA_HOME="$(/usr/libexec/java_home)"
    EOS
  end

  test do
    system "#{bin}/schematool", "-initSchema", "-dbType", "derby"
    assert_match "Hive #{version}", shell_output("#{bin}/hive --version")
  end
end
