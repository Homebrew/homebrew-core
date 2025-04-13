class Cproto < Formula
  desc "Generate function prototypes for functions in input files"
  homepage "https://invisible-island.net/cproto/"
  url "https://invisible-mirror.net/archives/cproto/cproto-4.7x.tgz"
  mirror "https://deb.debian.org/debian/pool/main/c/cproto/cproto_4.7x.orig.tar.gz"
  sha256 "fb24b7254d8a5118913d3b7a54331975e60553afc70b88e4e7c2998203478cfe"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/cproto/"
    regex(/href=.*?cproto[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74d14e6a7fe7d38a689657640c86f216d7ac5a5a472dac25d11a0668b5a76cb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7d8b448e7cac556d0061b2009604cbaf8eab809ce5d49ead798537ce6a707c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4fd395a6bca7ab53b5d1ec26d42cffdf5eae1d09d2dfbabf97a272433783304"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fa78ac025b54e39d8bde868a2448c3bcfefb75ae582e44f35e0b8b371359245"
    sha256 cellar: :any_skip_relocation, ventura:       "321f6ca8a2ed5969e8e122279366e2c9b66457384599ab66fa3fb54d24348fb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6d089f8bb6c3d23578d7c96e83b9cc23404363db522297c3ee935afa3c3776e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b48c6f4e571b667be12169a26d7b873fa73e22bbfabd5be8d4af34c5056f488e"
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
