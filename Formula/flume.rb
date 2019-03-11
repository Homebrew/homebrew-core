class Flume < Formula
  desc "Hadoop-based distributed log collection and aggregation"
  homepage "https://flume.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=flume/1.8.0/apache-flume-1.8.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/flume/1.8.0/apache-flume-1.8.0-bin.tar.gz"
  sha256 "be1b554a5e23340ecc5e0b044215bf7828ff841f6eabe647b526d31add1ab5fa"

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
