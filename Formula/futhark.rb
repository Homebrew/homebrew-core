class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.24.2.tar.gz"
  sha256 "ff3500bcc26e7007f6010389fcde18ea8a348e12ab127f41a98b6a22949f5918"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "346cc48113506eaa27c2720db77468a86d3ad91dfe435002cd447e99e03389fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d73674f47705eea1f48ee54c4eb8dd85a63c97a2c518b5242ee258b4f5c8152"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d61be1f72db2ca76b363a42af8c725982a993fdacddec43f05014e8da6146b5"
    sha256 cellar: :any_skip_relocation, ventura:        "8ab46937627b9301acddd086bfc55a987d1cbc1137409c9e3093531a5cfd063c"
    sha256 cellar: :any_skip_relocation, monterey:       "0b4703a6b1a0f0c13fa29da15e735ec8910e6ec1fa03cbc18014643393cf1dc6"
    sha256 cellar: :any_skip_relocation, big_sur:        "48d74dc17be426371ff81e1aaaf0fc31b39e6fe1272c6dfcb7e37fbca636af82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29a6fc3200c4c4e08f3a0d4b9de266b2d2bace122550049697ad693fb562d68a"
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
