class Flume < Formula
  desc "Hadoop-based distributed log collection and aggregation"
  homepage "https://flume.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=flume/1.6.0/apache-flume-1.6.0-bin.tar.gz"
  sha256 "0f7cef2f0128249893498a23401a0c8cb261e4516bc60f1885f8a3ae4475ed80"

  bottle :unneeded

  depends_on "hadoop"
  depends_on :java => "1.7+"

  def install
    rm_f Dir["bin/*.cmd", "bin/*.ps1"]
    libexec.install %w[conf docs lib tools]
    bin.install Dir["bin/*"]
    bin.env_script_all_files(libexec/"bin",
      Language::Java.java_home_env("1.7+").merge(:FLUME_HOME => libexec))
  end

  test do
    assert_match "Flume #{version}", shell_output("#{bin}/flume-ng version")
  end
end
