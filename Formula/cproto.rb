class Cproto < Formula
  desc "Generate function prototypes for functions in input files"
  homepage "https://invisible-island.net/cproto/"
  url "https://invisible-mirror.net/archives/cproto/cproto-4.7u.tgz"
  mirror "https://deb.debian.org/debian/pool/main/c/cproto/cproto_4.7u.orig.tar.gz"
  sha256 "64ebbbcc5e0501aff296f431d06f9fb70863afe5b0ce66c3b3479072914fc51e"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/cproto/"
    regex(/href=.*?cproto[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2907353ffb14ed7b6972aaa876f5012417fd17b6274b5d5ecf496bc40450794"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad283dcee4c414e2e395f42dafb30c2fabe2e1bf59c564273c93f82aa10cae3a"
    sha256 cellar: :any_skip_relocation, monterey:       "29f7fc4efd440cb4672468744eeb43e4d952c6f75a8da271b4a807d0e767ecc2"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2a613fe2f6321208ffc402856d463b072e975b85be728cca1fe3ec47863e9e8"
    sha256 cellar: :any_skip_relocation, catalina:       "83cedf6fa84b3d01c5bd5883d5e52291b8e63861cf493b6492bf2250b09e02da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c83f959881b5228a43999fe0c3b679fd575375b8f7bb1e322580c323db94644b"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    (testpath/"woot.c").write("int woot() {\n}")
    assert_match(/int woot.void.;/, shell_output("#{bin}/cproto woot.c"))
  end
end
