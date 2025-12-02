class Arpoison < Formula
  desc "UNIX arp cache update utility"
  homepage "http://www.arpoison.net/"
  url "http://www.arpoison.net/arpoison-0.7.tar.gz"
  sha256 "63571633826e413a9bdaab760425d0fab76abaf71a2b7ff6a00d1de53d83e741"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?arpoison[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "befc347407af6f1c5581b82628c49605b87c84b2ce0b2d75f4641496c9ad8789"
    sha256 cellar: :any,                 arm64_sequoia:  "5290454e5c88457099cf20619c7bbb8368c13c8a33365791781c7ef693fa6a1e"
    sha256 cellar: :any,                 arm64_sonoma:   "2c6f2456c9b2ba1ac193df313e5b48ffe0ec438d0a4abce2a0913a77783e04a1"
    sha256 cellar: :any,                 arm64_ventura:  "fda2504283a2fc1da565c46545d392afca3bf569aab288480f0d2521898a1967"
    sha256 cellar: :any,                 arm64_monterey: "26c33452df47e5d7ec7953bce6aab14f87ea5151363530593440964bacd36266"
    sha256 cellar: :any,                 arm64_big_sur:  "376ce845d964f61c095ab7a16d2645d3688ebf5810b18dfb8badb8a24da0e66f"
    sha256 cellar: :any,                 sonoma:         "44c3875b6b3a12730676cab6eb35ca21b7e7d101cf5aa5647ea8711574e2fb04"
    sha256 cellar: :any,                 ventura:        "eee365fdbdf0f7a61b4a2ca6f97f62d3a011bf9b4d27b30ec20ffb7f088633cf"
    sha256 cellar: :any,                 monterey:       "efb931a73eccda7ae706e9138112c9ecb898fd09c42dcb0876b85899734eb93f"
    sha256 cellar: :any,                 big_sur:        "2009a1bff74b3d6e4fd4eb5f76ce104473e1c322e2f666cf3f5962de2bc99a0c"
    sha256 cellar: :any,                 catalina:       "550588e02ce0eb78b47d2d2f9e8b863c29761667aca72e4ad0c0810b13682d9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "75d63e2ad84b69dae9d22fde3a7a2faaa8f35b67766ae1ca1e7c7fcfd79de484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d1b74e30daecd8e66750565482b964566fbb0b323f86f360de9f0b1ad332cec"
  end

  depends_on "libnet"

  def install
    inreplace "Makefile", /gcc -lnet (.*)/, "gcc \\1 -lnet" if OS.linux?
    system "make"
    bin.install "arpoison"
    man8.install "arpoison.8"
  end

  test do
    # arpoison needs to run as root to do anything useful
    assert_match "target MAC", shell_output(bin/"arpoison", 1)
  end
end
