class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.17.tar.gz"
  sha256 "5ec6402ac08e5cc03438c70dc3339e7de7cfd1962d1c877854e47d154d7e036f"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33adc28b50596b15fa1f347ee4636b80a5066aeb6b43a051f78563d0a9d2c338"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "851d692bcaf21e5319b17683d1551cf3d01664cfd219ee5f660e86d90b322593"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "110b0b03e1a97e2b2bd69057bccc853738379038a506f8fff22814be80d8ce9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "dea51e187f4dd4a2c27e247f8fb58686781902dcfee23c3672f6f042101b8cef"
    sha256 cellar: :any_skip_relocation, ventura:        "36417734afa63c9dcab6010fd6a3b87d03d2130afc721aa0a42daf5b01c320da"
    sha256 cellar: :any_skip_relocation, monterey:       "39708dd33c97b9ea65ef529ec856fa42b9331b93bbc27ba2277c1f15671ee8d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c36c11017e9939d20b4e2dff019056edc9f1db2a50d345dda2254f74f763b368"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args

    system "make", "-C", "docs", "man"
    man1.install Dir["docs/_build/man/*.1"]
  end

  test do
    (testpath/"test.fut").write <<~EOS
      def main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system "#{bin}/futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
