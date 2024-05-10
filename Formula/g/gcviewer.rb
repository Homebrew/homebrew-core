class Gcviewer < Formula
  desc "Java garbage collection visualization tool"
  homepage "https://github.com/chewiebug/GCViewer"
  url "https://downloads.sourceforge.net/project/gcviewer/gcviewer-1.36.jar"
  sha256 "5e6757735903d1d3b8359ae8fabc66cdc2ac6646725e820a18e55b85b3bc00f4"
  license "LGPL-2.1"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/gcviewer[._-]v?(\d+(?:\.\d+)+)\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7d865411895953fdfe7f5bd70c844a93bb1c24470e36e0904aedef305e79ab7a"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"gcviewer-#{version}.jar", "gcviewer"
  end

  test do
    assert_predicate libexec/"gcviewer-#{version}.jar", :exist?
  end
end
