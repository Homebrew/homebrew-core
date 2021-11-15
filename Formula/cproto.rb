class Cproto < Formula
  desc "Generate function prototypes for functions in input files"
  homepage "https://invisible-island.net/cproto/"
  url "https://invisible-mirror.net/archives/cproto/cproto-4.7s.tgz"
  mirror "https://deb.debian.org/debian/pool/main/c/cproto/cproto_4.7s.orig.tar.gz"
  sha256 "842f28a811f58aa196b77763e08811c2af00472c0ea363d397a545046d623545"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "272e257cff2d16846104e4877d7589e55a53f258f1217d8057ac7d1ca6f5f4f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a088886e46774e58acd6be39d2adebb92c2b2c4830dc42c86e7738cfc0320bb7"
    sha256 cellar: :any_skip_relocation, monterey:       "ee036c975556b8d793dd0f0fe145a76156aae4ff36216e54fe30573bcd5d81f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "437ad7aaed7ef07a8a036d407449bae1c7dce5dbe5e1b4670500a5afbaa35497"
    sha256 cellar: :any_skip_relocation, catalina:       "1c65ad43afdc60cf09bb9a7799206f12355dbf6d35561266430170e9916a47f1"
    sha256 cellar: :any_skip_relocation, mojave:         "28c219e904fe9e233fe01d9f521b241122b0ed79355062ce40f3ef039f317776"
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
