class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.19.1.tar.gz"
  sha256 "fc1b01e09ccec2216eff925416c5dbb09586a7fa60366984796f2826acd0f87a"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "5d034e01bf376057bc917d4c7be9c7aaf93a1a66db778663996c9bf3fcf8be0a"
    sha256 cellar: :any_skip_relocation, catalina: "f9c5cf5037da7222c7a3df43ca0abba8bb60e1181b065d1a5a1b2a09702937b2"
    sha256 cellar: :any_skip_relocation, mojave:   "91cb4a2ab757e54467665b2ee9c9ed6354cffa90c4ce9bbdd9c5f7b4e43f521b"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    # Remove the `--constraint` flag at version bump
    # see https://github.com/ddssff/listlike/issues/8#issuecomment-748985462 for detail
    system "cabal", "v2-install", *std_cabal_v2_args, "--constraint=bytestring==0.10.10.1"

    system "make", "-C", "docs", "man"
    man1.install Dir["docs/_build/man/*.1"]
  end

  test do
    (testpath/"test.fut").write <<~EOS
      let main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system "#{bin}/futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
