class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.33.tar.gz"
  sha256 "d794ab7189b9b174f0bf33e5f596cc367b507692303baed30fa07c8ac6d31427"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b8c6ac96421de2a0adffc2b80438a4126d8da58d3223cd5088b38f20eda1ec66"
    sha256 cellar: :any,                 arm64_sequoia: "bfbb2c2ec8abb82852696c2220851e9c8790b08affb9bf51e4d4175f0dd423e0"
    sha256 cellar: :any,                 arm64_sonoma:  "5470c14ccaffbb410d3855461e6d43ada21bbab4c9ef7b8d19e461872f1d0894"
    sha256 cellar: :any,                 arm64_ventura: "9655bbc2d0b351c5474cac08c17ba58198fc466c231626116f070f44421a47d8"
    sha256 cellar: :any,                 sonoma:        "ca6407c90ab244a47f625f1d7dd0177b76d5973100ef2d9a207cbc38c73fb689"
    sha256 cellar: :any,                 ventura:       "d5e0c2db2ba8836b909302e11ac5fc639b1fefe2ceb0496663d304795ae01886"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "071b5a23eee4893906fb3a4851db0f5e607424b11f7204f99b9f8f8b90b62dc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c32dbff41d733df9e3f83d9044222e5294231d7cd6d7d01b301f2d391e3abdd"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
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
