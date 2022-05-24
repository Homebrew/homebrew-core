class Cproto < Formula
  desc "Generate function prototypes for functions in input files"
  homepage "https://invisible-island.net/cproto/"
  url "https://invisible-mirror.net/archives/cproto/cproto-4.7t.tgz"
  mirror "https://deb.debian.org/debian/pool/main/c/cproto/cproto_4.7t.orig.tar.gz"
  sha256 "3cce82a71687b69e0a3e23489fe825ba72e693e559ccf193395208ac0eb96fe5"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13b780ef3e9078c16847e134c3bf54ca9b8af8504b3cf5f4ed3bf493bad1493f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71bca925406cc678f69551bb66d465d44376bc1f1854aba91003218dae5cdadf"
    sha256 cellar: :any_skip_relocation, monterey:       "6079a4a6df45f570734658bfda2197d6b9542a706cf0176f39be008f9e327a45"
    sha256 cellar: :any_skip_relocation, big_sur:        "90f6050bc98803612e77e1464bdacd518fbbf0f62607508ab1018553f0d59713"
    sha256 cellar: :any_skip_relocation, catalina:       "9f2cdd0ade5c49f112c2e87c5a18c9990805bc8447ad4e0350fafa26b08ac244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cac5bb9129add6096d8890380543218b9e8028566074e4239d7b0072d519f2d"
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
