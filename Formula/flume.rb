class Flume < Formula
  desc "Hadoop-based distributed log collection and aggregation"
  homepage "https://flume.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=flume/1.9.0/apache-flume-1.9.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/flume/1.9.0/apache-flume-1.9.0-bin.tar.gz"
  sha256 "0373ed5abfd44dc4ab23d9a02251ffd7e3b32c02d83a03546e97ec15a7b23619"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "734753080fb6c3c2446b483ddf29032c997886c75470e0f43f7a0f489eceb3d8"
  end

  depends_on "hadoop"
  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.cmd", "bin/*.ps1"]
    libexec.install %w[conf docs lib tools]
    bin.install Dir["bin/*"]
    bin.env_script_all_files libexec/"bin",
                             JAVA_HOME:  Formula["openjdk"].opt_prefix,
                             FLUME_HOME: libexec
  end

  test do
    assert_match "Flume #{version}", shell_output("#{bin}/flume-ng version")
  end
end
