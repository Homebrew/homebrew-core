class Megatools < Formula
  desc "Command-line client for Mega.co.nz"
  homepage "https://megatools.megous.com/"
  url "https://megatools.megous.com/builds/megatools-1.10.2.tar.gz"
  sha256 "179e84c68e24696c171238a72bcfe5e28198e4c4e9f9043704f36e5c0b17c38a"
  revision 2

  bottle do
    cellar :any
    sha256 "d70a82b2a19ce986fd41511a0f589e91fc5e0bd0cc6205abf674cdfacb836266" => :mojave
    sha256 "f98f3d41a95a1ab3bdeaaf57e18170ceb8cee53b1cc9050bb026a92ed6dfbcd1" => :high_sierra
    sha256 "84fe224094799395a0a09c2c26d68dc76c4c06aa4dfd60c3acacb615470fa14f" => :sierra
  end

  depends_on "asciidoc" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "glib-networking"
  depends_on "openssl@1.1"

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
