class Gcviewer < Formula
  desc "Java garbage collection visualization tool"
  homepage "https://github.com/chewiebug/GCViewer"
  url "https://downloads.sourceforge.net/project/gcviewer/gcviewer-1.36.jar"
  sha256 "5e6757735903d1d3b8359ae8fabc66cdc2ac6646725e820a18e55b85b3bc00f4"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/gcviewer[._-]v?(\d+(?:\.\d+)+)\.jar}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a328eede0efee60ae573264f46a858ad1719edd56e787e0ce9aadeac6ed017c9"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"gcviewer-#{version}.jar", "gcviewer"
  end

  test do
    assert_path_exists libexec/"gcviewer-#{version}.jar"
  end
end
