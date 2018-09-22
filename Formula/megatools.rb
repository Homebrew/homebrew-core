class Megatools < Formula
  desc "Command-line client for Mega.co.nz"
  homepage "https://megatools.megous.com/"
  url "https://megatools.megous.com/builds/megatools-1.10.2.tar.gz"
  sha256 "179e84c68e24696c171238a72bcfe5e28198e4c4e9f9043704f36e5c0b17c38a"

  bottle do
    cellar :any
    sha256 "68c1b72427e231c8bb1d05c79e78b0159eef3a9efec2ab6e11428813ecd39206" => :mojave
    sha256 "f18ae236c38b575b3524c3dd1762b6291257231fdbadd09c8c84ef166cc3c34c" => :high_sierra
    sha256 "096b9459462956a3257a8869154f9ce3003decaf3ed4f20ef65ba4d6094abc11" => :sierra
    sha256 "956a0731c11c8ae3f999386cc95d57a787a19ad7ead8007b09efc7a96412c034" => :el_capitan
  end

  depends_on "asciidoc" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "glib-networking"
  depends_on "openssl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Downloads a publicly hosted file and verifies its contents.
    system "#{bin}/megadl",
      "https://mega.co.nz/#!3Q5CnDCb!PivMgZPyf6aFnCxJhgFLX1h9uUTy9ehoGrEcAkGZSaI",
      "--path", "testfile.txt"
    assert_equal File.read("testfile.txt"), "Hello Homebrew!\n"
  end
end
