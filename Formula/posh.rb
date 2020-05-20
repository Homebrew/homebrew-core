class Posh < Formula
  desc "Policy-compliant ordinary shell"
  homepage "https://salsa.debian.org/clint/posh"
  url "https://salsa.debian.org/clint/posh/-/archive/debian/0.14.1/posh-debian-0.14.1.tar.bz2"
  sha256 "3c9ca430977d85ad95d439656269b878bd5bde16521b778c222708910d111c80"

  bottle do
    cellar :any_skip_relocation
    sha256 "feed2fe4790da6503fd829889f4ca5aa70f7716e1329cae79d92e84c9142ae69" => :catalina
    sha256 "700e48f30128fa0fdd35c3117154dd24455ba2a8839bd56fda146f5cf8e4eb11" => :mojave
    sha256 "9c38d14973e3fd33480cfdb45442a1e2e5291d4a60008ea61c689d497f8ff7ef" => :high_sierra
    sha256 "d8528d6120edc6a45b43c7e3b148b5cb8859dcd10ee24c60ae7b1c7cfaa992d5" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/posh -c 'echo homebrew'")
    assert_equal "homebrew", output.chomp
  end
end
