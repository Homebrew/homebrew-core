class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  # TODO: Try to switch `ghc@9.4` to `ghc` when futhark.cabal allows base>=4.17
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.14.tar.gz"
  sha256 "859a31828dc897b06d39a576c16fb7263cad3a664535bf81460dbc70efa88450"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d2543f06bea8c1fc300ad359ac093096595c98b8e7e236caba2d247aff0f56b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae75d8fbada547b0c775b94d875a04f4d9ca29059f6c57bf9042358463fadeb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24aec4d778954f024c6358c0add536c10c5c127b3ef023b291222e7d437908f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea3161c981b708993c37fee9afebeb6f8f7082dd1923555b4e5728ed443804ba"
    sha256 cellar: :any_skip_relocation, ventura:        "fc5de7644d7b96062f15758fa045df1e9ed780aa20352803c25f25434201891a"
    sha256 cellar: :any_skip_relocation, monterey:       "2f053c0ba0dae3c9c54c48964496653cfdc4d5302adc959965fdbf6f102205a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "907392ae38051cce6c7ffad4bb95088909aece5e9b49581689f6cb334680848f"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.4" => :build
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
