class Flume < Formula
  desc "Hadoop-based distributed log collection and aggregation"
  homepage "https://flume.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=flume/1.11.0/apache-flume-1.11.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/flume/1.11.0/apache-flume-1.11.0-bin.tar.gz"
  sha256 "6eb7806076bdc3dcadb728275eeee7ba5cb12b63a2d981de3da9063008dba678"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "48db8221f283446a57987c14a36acd4cc21848c24ca31b00f45b59ed12bf3710"
  end

  depends_on "hadoop"
  depends_on "openjdk@17"

  def install
    rm(Dir["bin/*.cmd", "bin/*.ps1"])
    libexec.install %w[conf docs lib tools]
    prefix.install "bin"

    flume_env = Language::Java.java_home_env("17")
    flume_env[:FLUME_HOME] = libexec
    bin.env_script_all_files libexec/"bin", flume_env
  end

  test do
    assert_match "Flume #{version}", shell_output("#{bin}/flume-ng version")
  end
end
