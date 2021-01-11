class Cproto < Formula
  desc "Generate function prototypes for functions in input files"
  homepage "https://invisible-island.net/cproto/"
  url "https://invisible-mirror.net/archives/cproto/cproto-4.7q.tgz"
  mirror "https://deb.debian.org/debian/pool/main/c/cproto/cproto_4.7q.orig.tar.gz"
  sha256 "f36e0d4472cbdb257b10e61b333fb8cf59e26dff390ea3595bcbaa498d2c168d"
  license all_of: [
    :public_domain,
    "MIT",
    "GPL-3.0-or-later" => { with: "Autoconf-exception-3.0" },
  ]

  livecheck do
    url "https://invisible-mirror.net/archives/cproto/"
    regex(/href=.*?cproto[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "74853b756108f1bc8cea4d4f64affa9cbb8b5cd1d95c249c84657e87454830b7" => :big_sur
    sha256 "aa8125b23456cc61c0bd50aca5372729445fe4e21d579317e04dc4f1607760ed" => :arm64_big_sur
    sha256 "05936e555dc7f1cbe36cebf67e20de0f7c0404db6cbf1ee23f69aa4a858281db" => :catalina
    sha256 "5123cb4d20d57211cd5348087194fcbaff4f79b0e45317e2d82f82c3c54b42da" => :mojave
    sha256 "ecd7b1cb65d67008fe7b904a24d60df256d4d3d88cf7fff6647adf98db5a411c" => :high_sierra
  end

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
