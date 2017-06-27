class Moe < Formula
  desc "Console text editor for ISO-8859 and ASCII"
  homepage "https://www.gnu.org/software/moe/moe.html"
  url "https://ftp.gnu.org/gnu/moe/moe-1.9.tar.lz"
  mirror "https://ftpmirror.gnu.org/moe/moe-1.9.tar.lz"
  sha256 "18919e9ffae08f34d8beb3a26fc5a595614e0aff34866e79420ca81881ff4ef3"

  bottle do
    sha256 "ff9de589a2c3d65b95ab1d137b8ee56e54f3a0f64a43d8d0dc8ebede9369cba7" => :sierra
    sha256 "9d2c0647210a48775c9d829d50c91966bf7a4ca2c6485ad7b906a2b9582db778" => :el_capitan
    sha256 "94983572209b4fcebc765e1a74738eab64f239a97f02d919867ce49105622fdb" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/moe", "--version"
  end
end
