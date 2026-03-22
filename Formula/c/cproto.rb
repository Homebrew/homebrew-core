class Cproto < Formula
  desc "Generate function prototypes for functions in input files"
  homepage "https://invisible-island.net/cproto/"
  url "https://invisible-mirror.net/archives/cproto/cproto-4.7y.tgz"
  mirror "https://deb.debian.org/debian/pool/main/c/cproto/cproto_4.7y.orig.tar.gz"
  sha256 "0bd1d8be8ff0a4ca43f947f95750d34f64eda93c9e2ca79100fd60140b7c6331"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/cproto/"
    regex(/href=.*?cproto[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58bffd226d337b3dafa76c0826592375412dbd7c168f4c0a1c77c97a029f7f5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb3de8c47565f6ec10acd1481ad063139c9147a86d9fe9082dcf21bc29905889"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "122d4b64c1aace8c5424428c5a92a62904571e65837713fc4b851e9f94b8aa54"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d0ad1d890320e7f0c515df9b7b8dc3539f9a4325e41dd4d7f6a0425976fcf2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce7a3c81d6c61db780af378231e6c03f34ae2b9781391ea6a8a08d35c606a960"
    sha256 cellar: :any_skip_relocation, ventura:       "66e49c9ef793c0c0c3b874224283e1aba46de0b03c91bbc406816ad4462cbfe6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b439e277afd138e4921a535b01d8e2ea791e3bcb2c0d5c4dfc43ca85535d78f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79811b19af9c17898e97d36b997ceefee377b25273d783de07ec8c01a59f2d51"
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
