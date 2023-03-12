class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.24.1.tar.gz"
  sha256 "f56fae52411ed951df613d3ec914118bb573f42f155f46d243f813108cb2c494"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f22ed7743b8626c7f28b238a28a3e90e5aaa1dfbc7398e8f959bb4a5d5bb7d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b05698fd66729cfaf8a7abbab96a1d8b4c2622ee00dc1de04f090dc443bacc5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6585901ca2aa73bdfdec71145e0f74971ae696677bf196d18a0de5fd2270a92"
    sha256 cellar: :any_skip_relocation, ventura:        "2281a0f86330b5f5c16fb62c1b820b8cc3f5e96334fb6ce30bc23bb8184a9779"
    sha256 cellar: :any_skip_relocation, monterey:       "997434fd4f09cb564d46c470607ecc99e5dfb0c2b7aa8e460bc9f33d6c6e7e05"
    sha256 cellar: :any_skip_relocation, big_sur:        "220cfea50807cdba9d9c853f53f12b708b0447ed8a4af14b77f65e37d3f3b97f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2a57e65c1e87fa04a828431ad1785cf51feb6af1c62f498056d13ba828c72fa"
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
