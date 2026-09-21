class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://tracker.debian.org/pkg/debianutils"
  url "https://deb.debian.org/debian/pool/main/d/debianutils/debianutils_5.24.tar.xz"
  sha256 "bf79c301ad48e82ddb09d8c0770f6d44294ee9529ae5e54164072f7bf5c57016"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?debianutils[._-]v?(\d+(?:\.\d+)+).dsc/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c74754e405c7195416a6eee7185c7fc6cc5667911d3c15eff4a299616f0ae4c2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bfb469effa35c07c7e0f45d63dfa6ac0829cf2c50c1e043dc9443dcd0f08f993"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "65e5a7a6ddd283487b870de85d0923236cf73a859cb9d6eef4a7cefd23ff5d9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "01995d50a7cdf817d4c385cb46f81b23e341db6c221ac3ed8a7c0ba618f458e9"
    sha256 cellar: :any,                 arm64_linux:       "c8477c286845207791beae9fbdd4c3bba1a784d90eebba6760a23c61776cda4e"
    sha256 cellar: :any,                 x86_64_linux:      "eecd6810a9b410c133cb88b65f6855fd46c9073f2ae410a5daf784815d44cddf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build # for libintl
  depends_on "libtool" => :build
  depends_on "po4a" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"

    # Some commands are Debian Linux specific and we don't want them, so install specific tools
    bin.install "run-parts", "ischroot", "tempfile"
    man1.install "ischroot.1", "tempfile.1"
    man8.install "run-parts.8"
  end

  test do
    output = shell_output("#{bin}/tempfile -d #{Dir.pwd}").strip
    assert_path_exists Pathname.new(output)
  end
end
