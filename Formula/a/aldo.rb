class Aldo < Formula
  desc "Morse code learning tool released under GPL"
  homepage "https://www.nongnu.org/aldo/"
  url "https://savannah.nongnu.org/download/aldo/aldo-0.7.7.tar.bz2"
  sha256 "f1b8849d09267fff3c1f5122097d90fec261291f51b1e075f37fad8f1b7d9f92"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/aldo/"
    regex(/href=.*?aldo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "c79608f02c4c17db23e84db17545e895475a4a38e46419b37d7b518a40363e73"
    sha256 cellar: :any,                 arm64_sequoia:  "85ae21042606044840664aafe2df3fdcdbc6b00274ef715522d1e14964e51643"
    sha256 cellar: :any,                 arm64_sonoma:   "b213535da0d7e8de96c6d529a82d17beabea2b2fc54a7a0b4ef9e1e0787dc2b0"
    sha256 cellar: :any,                 arm64_ventura:  "0d999e5927c28aec07c5e74d61f3338129c4040bd34c35e12a3da993b0de90c0"
    sha256 cellar: :any,                 arm64_monterey: "434e524f42b70dd31c05c80d41808af6b68d13875376d38ef86dba496b86b609"
    sha256 cellar: :any,                 arm64_big_sur:  "a0944cbf0df1cccd63c1d18cf758826e8b7621c188b60603153b717ba9d2edbf"
    sha256 cellar: :any,                 sonoma:         "ce5f647836b60f1d2b19e47b7dd445e4a3005c478746c36fe4ec08e1a03a79a4"
    sha256 cellar: :any,                 ventura:        "e81b0d99b63abac08c7768f017eae3c9d059012fa8867f0ff8d3d5bf76e81b7b"
    sha256 cellar: :any,                 monterey:       "266951db532a823d9241ad3e29d0e07b63f5b7dc5d4fcae3b3dfed117dfd9488"
    sha256 cellar: :any,                 big_sur:        "b6e5c413c1ca391cd040cadd7d2c153e7552ce43677da0d0f1aab1467e92bb3b"
    sha256 cellar: :any,                 catalina:       "2a574bfd1a76ef4733d941234df142dfc87b05cefefaf58d0617113d7af85999"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "41aaf9303c8e8cac32a159590dc0e3f1c905d591cebf215a0e699c893feced08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "660548eb8c93e2c78a50b925143a9b24400ee578790b62e7acde1d1aed360a98"
  end

  depends_on "libao"

  # Reported upstream:
  # https://savannah.nongnu.org/bugs/index.php?42127
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/aldo/0.7.7.patch"
    sha256 "3b6c6cc067fc690b5af4042a2326cee2b74071966e9e2cd71fab061fde6c4a5d"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Aldo #{version} Main Menu", pipe_output(bin/"aldo", "6", 0)
  end
end
