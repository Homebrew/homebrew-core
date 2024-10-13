class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.22.tar.gz"
  sha256 "6dc0c421d5b9d42ee7e2ae3077bd1f57541b770e00c6788dee4b3ee0623c925f"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1910af5b6bbc117ce25af60d4e42ac1d0eaa481f9354445b9db7bca03b12e57e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3827524731a9d2aee6f0510ca462829c521fff2a1a671500497ccad5c529afb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aab58cc6a02bafde81c166009c7e1959868ec3178103cf28e44cb1b1de327aff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dd9c2ddaa7be53af7b899704cb7d3d0b8247bf566d26b1767b2923445d6578f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0082b4551e248898192969992b261fc2f54d9f11cf2e04b6b61ed85e38eb682"
    sha256 cellar: :any_skip_relocation, ventura:        "77526ca3656d2aa4d8ac0debbdebd8e0e0cbef6d8f3e8252f6c19028ca5afe94"
    sha256 cellar: :any_skip_relocation, monterey:       "4b2570649cad6ba600283f0d1025f785ff16444fa52329d129f65ad7abb96cb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e346da5c3dfb9dade19bec85bf77c9bc6dfb39ac9e7e86c4a8f35717c0c4e034"
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
