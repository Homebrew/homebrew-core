class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.13.tar.xz"
  sha256 "b3498466c65b650add1a6e79209b27ba86375673a45c96a5927bed685a327dc1"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/mpop/download/"
    regex(/href=.*?mpop[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "a9061a1fd7dfb9f9f73b511a5fd8b476cd57e7336e49c146b999da3afc639753"
    sha256 big_sur:       "8666c6f36ee3f3ed758139f4aceb22128b2c05c9ccaf47a538ef649d6daf598b"
    sha256 catalina:      "651b41a0c11959ff187840e7bb0f036912a2611555b12c2d6ca5536d9356bdb2"
    sha256 mojave:        "7e0f134fcfd8d0d032b53a24a9d6c19cc92f5856a1f5fbfc432e7bf13ec51dd8"
    sha256 x86_64_linux:  "ad69b17457afb8dab7e6827efe8f78603eaa69a85073fdc02b0d457a2fc599e0"
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpop --version")
  end
end
