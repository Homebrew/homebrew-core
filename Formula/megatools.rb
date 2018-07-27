class Megatools < Formula
  desc "Command-line client for Mega.co.nz"
  homepage "https://megatools.megous.com/"
  url "https://megatools.megous.com/builds/megatools-1.10.1.tar.gz"
  sha256 "9938127db27b579d49aa8722bfdddd17833fe90668aa2670ce88d1c889452d67"

  bottle do
    cellar :any
    sha256 "b907af7c88a5b1f23643bd5576050ba6e228a0475246e8645b8f0d71dd97d81e" => :high_sierra
    sha256 "67fc6d534eb92276f21feea903ae682f8b5318da9eb59b1a94cc3887f9855c1f" => :sierra
    sha256 "e0bae7222466e43ae48615a9cea006527be27d4d44b9943b0b37d7e45f623704" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "asciidoc" => :build
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
