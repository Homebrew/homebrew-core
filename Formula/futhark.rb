class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.22.6.tar.gz"
  sha256 "d0f116f8f89f37eafca31fc7c7db79f6be353d1e5b59afff9d486482f4df740b"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9118e474fa11e54b6cc3b9b2e2e46c69a4cfdc409e27ae19a3fc8b6e3111bc1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12cfd365b2b59120863a894f8fdc4b6a3b6d338a5db48ba19440d7c5f176580a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b4a2960cc98c928787d28160b36a6e691ae2774ed88fb7522c3044da959f54a"
    sha256 cellar: :any_skip_relocation, ventura:        "39966aaeb1c668d234bcc2c1d8a4ac066216e04594a3dffe0cb9d35b889f8235"
    sha256 cellar: :any_skip_relocation, monterey:       "533edb700964e6410f7336ba1749b5c2e6b074b84819ab4f803afefeae0557f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9fad7edd7a16853dbde154519f3d8209ee48b5a5a236b02a46526ceeaadbe0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e7e7a1d5967c8fec12ca4301b26ef2182b2c4485346db4691be014c117ddca5"
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
