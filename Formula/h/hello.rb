class Hello < Formula
  desc "Program providing model for GNU coding standards and practices"
  homepage "https://www.gnu.org/software/hello/"
  url "https://ftpmirror.gnu.org/gnu/hello/hello-2.12.3.tar.gz"
  sha256 "0d5f60154382fee10b114a1c34e785d8b1f492073ae2d3a6f7b147687b366aa0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d542fba541d655b431c64e07b0a2f020fa1b47cf7213bddec73d51f6b1246e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce9f4dd817532429fb3b890a901da44fa66f0540e242321f40fa12231f5ffa60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2d2936b723280b7ea2fd38d977fbce0c20919e3a483229d0b4f4c96800e4d7c"
    sha256 cellar: :any_skip_relocation, tahoe:         "d3c167221f723235eed887d3116ba656ecb4d2c824e4a04037bf63dca96ce227"
    sha256 cellar: :any_skip_relocation, sequoia:       "d0ec57cc9a6a0ed8d035d8f19073d83f5dba21007c0d2815333d4908d40f98a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c55ce0232ee793fee24cea7dfce44f323e9b006eb49e6ff381678614e22aa3b5"
    sha256                               arm64_linux:   "1758c42f89b579961610910892bf56d9d637614a4bd505265ebce6e09240e397"
    sha256                               x86_64_linux:  "babafecd3b1c532d4e799de46f943f6384b5d78beffb52c9f4730e30ad374a70"
  end

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    assert_equal "brew", shell_output("#{bin}/hello --greeting=brew").chomp
  end
end
