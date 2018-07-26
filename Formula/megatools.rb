class Megatools < Formula
  desc "Command-line client for Mega.co.nz"
  homepage "https://megatools.megous.com/"
  url "https://megatools.megous.com/builds/megatools-1.10.0.tar.gz"
  sha256 "788a51d0977db95c371c97917aee3d39e145044b6bb70d671bc76c2ea6c4171b"

  bottle do
    cellar :any
    sha256 "dc602b26c3ac44df6084fde93ce90f7408145817963a184916dfd48e2a060276" => :high_sierra
    sha256 "570c02df45849ba7a223391ebb9df3bc31faabeb399a902256f013dbef167441" => :sierra
    sha256 "8a661afef3e014425b600bb65c4e20a3e71cd96b179e9d86cfde5e974a596d0a" => :el_capitan
    sha256 "26b90b76a9e2170b0c336d4175eff71665bc4f606e7ed4a86e66d3170fd4c4cf" => :yosemite
    sha256 "7ceca85be24834ffa98b2813996548d46fdc8b05e103b2d1ebeac97d39a9e670" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "asciidoc" => :build
  depends_on "glib"
  depends_on "glib-networking"
  depends_on "openssl"
  depends_on "curl" unless OS.mac?

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
