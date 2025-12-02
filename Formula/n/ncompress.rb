class Ncompress < Formula
  desc "Fast, simple LZW file compressor"
  homepage "https://vapier.github.io/ncompress/"
  url "https://github.com/vapier/ncompress/archive/refs/tags/v5.0.tar.gz"
  sha256 "96ec931d06ab827fccad377839bfb91955274568392ddecf809e443443aead46"
  license "Unlicense"
  head "https://github.com/vapier/ncompress.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "fb300d3e1ef4dc25fab6344cc7e6010bd55f0fa66403c3371f8d6b3f449d7645"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f7e39b3e6471d9335023fcc1434352de41fe4521adff432f237c4167c7de71fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f28dac0e82ae6c3642abb0648dbc64959c1822ca44f2b73a1afce7fb1335328a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5a549a65439192ba3656d246d95c57979228f95d5c9ccfe26be0fd9744dae1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dbd83bf79e6dc3934b84e104305dc7772100aafe85a724275a821d3a4c68762"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ed0a835e287915e90e45a75971aefd707578cf96ddcbe631fd8bab34000af98"
    sha256 cellar: :any_skip_relocation, sonoma:         "26e5b5ed48c9974e7d4616fc1dd8f7a8bb089cbf13e9a71e5978a278334a248f"
    sha256 cellar: :any_skip_relocation, ventura:        "c7bf47ebe6376a3b3a84b4441e8dff37c639cad3c00906a3aec98d6f2fdbe879"
    sha256 cellar: :any_skip_relocation, monterey:       "d209c387414dfd51d7f7bf079edce89699d6a60eb248bf48d90d1977dd3dbc4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b78cd2bde25384f42fd1f5d29ec6b1a909449e6f20c20c44c232885d0d99acbe"
    sha256 cellar: :any_skip_relocation, catalina:       "55220d13762facae37b84f1b6fcc6ec696daee5cc8b8478b868f5f7e34123af2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9b6c5d2b1203d6a07b51cfdf083c0dda44dd1133cabc7823da6093477f33ef4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cc0946635cd04b532b9c458ec215f1631d08dea366741346308d0030edfa05b"
  end

  keg_only :provided_by_macos

  def install
    # Remove archaic leading colon before shebang, so that brew install
    # cleanup code correctly preserves executable bit
    inreplace %w[zcmp zdiff zmore], /^:\s*\n#!/, "#!"

    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man1}"
  end

  test do
    (testpath/"hello").write "Hello, world!"
    system bin/"compress", "-f", "hello"
    assert_match "Hello, world!", shell_output("#{bin}/compress -cd hello.Z")
  end
end
