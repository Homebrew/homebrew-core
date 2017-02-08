class Myman < Formula
  desc "Text-mode videogame inspired by Namco's Pac-Man"
  homepage "http://myman.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/myman/myman-cvs/myman-cvs-2009-10-30/myman-wip-2009-10-30.tar.gz"
  sha256 "bf69607eabe4c373862c81bf56756f2a96eecb8eaa8c911bb2abda78b40c6d73"
  head ":pserver:anonymous:@myman.cvs.sourceforge.net:/cvsroot/myman", :using => :cvs

  bottle do
    rebuild 1
    sha256 "452b64835fbf52eec3d5b83532153caf2f0fd7c039b35b589031bbcc9db7f0ad" => :sierra
    sha256 "fb2e03ca7d79febb09bbb7f192fc2c6c3fa9cd401dbcd4dfae9b01746aa6faa6" => :el_capitan
    sha256 "60e5b8dca2b167ff37369ec25c208d653e716415e603f2a53db32186c05958cf" => :yosemite
  end

  depends_on "coreutils" => :build
  depends_on "gnu-sed" => :build
  depends_on "homebrew/dupes/groff" => :build

  def install
    ENV["RMDIR"] = "grmdir"
    ENV["SED"] = "gsed"
    ENV["INSTALL"] = "ginstall"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/myman", "-k"
  end
end
