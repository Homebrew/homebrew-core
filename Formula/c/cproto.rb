class Cproto < Formula
  desc "Generate function prototypes for functions in input files"
  homepage "https://invisible-island.net/cproto/"
  url "https://invisible-mirror.net/archives/cproto/cproto-4.7w.tgz"
  mirror "https://deb.debian.org/debian/pool/main/c/cproto/cproto_4.7w.orig.tar.gz"
  sha256 "8b1d468ccd9a2859f399c75fefbdca0dfdca4dc31891fedbc40ac5c326d27b6d"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/cproto/"
    regex(/href=.*?cproto[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5512528b422e8c4b6d66b0f6d48cffca6761acb05128c8f4126f4ea62ed4590b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d7f259ce8b7659bc353456a819e2d7eae0c4efca3447ecd252c96070ded8510"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e86b121521053baf82452696907062634de790c711e52785b60f2d77dd3f3d7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "208f3b8bb6aa9adf77d7c0a3a529bc4fa5d3eefaac9cad62a95d5ba28923872a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3de6c33bbc3e074ec9aeee140e877c47e7434f10be5bcaa480ba494cab880777"
    sha256 cellar: :any_skip_relocation, ventura:        "d2c386ef119d33a46f0a405f5117fac4be8c264973a28d06e5f517a2211f365a"
    sha256 cellar: :any_skip_relocation, monterey:       "aa263b50d6dee4059309287740fccf2961f79b41b0f09529b10f2275e9ea5e6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b14cf0184881bfbe0e06e17ed8274fa2c243a8ccfbfe83b9be62ef8c9c5a4dae"
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
