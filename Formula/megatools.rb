class Megatools < Formula
  desc "Command-line client for Mega.co.nz"
  homepage "https://megatools.megous.com/"
  url "https://megatools.megous.com/builds/megatools-1.10.3.tar.gz"
  sha256 "8dc1ca348633fd49de7eb832b323e8dc295f1c55aefb484d30e6475218558bdb"

  bottle do
    cellar :any
    sha256 "8bc25063a7dd2edf900b4441bacaaa161f2187ae3853b523aa8f3fc087aa9e86" => :catalina
    sha256 "0123f09bad922cd05a2e1822af57177b6ab4627819e28cb3142a5e34279a0d0e" => :mojave
    sha256 "51667c93fe6509b6ef663af3f9969fa70373a895cecfc2ce484cd3ab28f985bb" => :high_sierra
    sha256 "bc005a843021fcdde086fe8906599422717b96924403e7992612bec190e588a2" => :sierra
  end

  depends_on "asciidoc" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "glib-networking"
  depends_on "openssl@1.1"

  uses_from_macos "curl"

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
