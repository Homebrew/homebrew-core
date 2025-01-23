class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.26.tar.gz"
  sha256 "f1fb769bded311d5798cf64859c6f0f76528fa370fd5ca59263d68d6a243f4df"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5555255583c8e17457d6cb08bd636c664454ca144c0c9d5290ba7b6984973e78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f24cf6cc6ad945adde6cd765f8d3546798278e2a40fdf57017015a10b134678"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6d58e8c1f1fe408f739a587059d8471f6df4b9a7704f730ddea6cf2fedb3c1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcaa6d49ec21823dbbbf058a9e20f8b9dd555ac0061212bc8af5d3c06fc276a7"
    sha256 cellar: :any_skip_relocation, ventura:       "26589dda8e36014b1942fb2d9a7f5d4dbbeb3aed75f8f2961c6703c5e8e9697b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c0d680c0642863741c6d82becbe99bf0662a7021885f3b083d0eca382370da3"
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
