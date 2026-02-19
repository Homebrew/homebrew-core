class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.35.tar.gz"
  sha256 "847f9f75c2b64a06c062ce4c2987fb2be95898300d3562124a384b5a959b810f"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "22d92ed3e57b72e8b20bf34932dd4f6512e44246e8ca4e961620ae08c905a359"
    sha256 cellar: :any,                 arm64_sequoia: "54743d4ba0dfb6161440bdf4904d5f60e39d6847733e9f8035a94129ea6a3d04"
    sha256 cellar: :any,                 arm64_sonoma:  "9a27126cd44b9c287341b1ff590c2e264e933a97a202ca2cc41c77780e3ad008"
    sha256 cellar: :any,                 sonoma:        "13dac55e1cea82f61d2c00a831c39d7a72e95c6e82c5c989fdd69b9cecd8daec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f0dd464e91956580427a88ab402cca2f4bcc44e33c480bcd1c019f6ece30ddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f738ad85a53e18df02be3d9376290bb76da595431cdc1b356a8b92abe8752ad"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    system bin/"futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
