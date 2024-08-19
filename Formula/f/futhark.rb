class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.20.tar.gz"
  sha256 "93c721e56fb73a44c4b4311f3176922e5e8e20c77c3391bc1c34410930c29a74"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96b9931f4a0027bc6b4e022cb6038036c9f84c24723c21a045d4f9eb88188ae5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "453cbce70372f060257b6325222a4787034d98680c0e47cc87753e8881d75cba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cedeb16765e4661674aaf9b9b3e1f69c513ebcbb3d5db09820f6949f6924787c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9cf3c36c56bf8ceab2e13d0cd378d3824bf00acb08366db0f31d7f2696c2acc"
    sha256 cellar: :any_skip_relocation, ventura:        "8fd8bf48dbaf365b8c4b9451395ec099e4a7a0ef073aea1c960abb81a0a2fb5e"
    sha256 cellar: :any_skip_relocation, monterey:       "e0c08478890b784b3d83a21cdb258485a0235f2a6fc47d05fcd06a60ba085411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16cdc2832891df36084806265c8d682aaf6fa48fecb2ae07b88a7128a4e6a377"
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
    system bin/"futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
