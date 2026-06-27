class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.26.3.tar.gz"
  sha256 "88d5bbb020b4245df3c1f38134f97cacd3c85d77f6764aabbfbf520b180fe250"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "30abda0799d987c9230df3a72261705b6ac62a0389291b90efd8929245bf79cd"
    sha256 cellar: :any,                 arm64_sequoia: "eea38ef40c929029e0a1d4de0c4fd7d3cc37f985829898fa5e6fbca2d452cd52"
    sha256 cellar: :any,                 arm64_sonoma:  "619bb19946f4dbb3e2daa1aef9f606f1a3e213a5a7daf7a25d1b021e2155dfcd"
    sha256 cellar: :any,                 sonoma:        "9187d7433b5200419e7cc3f49dc8ca0ced032fef9a150c5d2ad5802d25ab0c0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecea0fd614a0cbb6ac5a953ea8a3386f4396ed829d197aac48ffa14643ed65b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57959ce3728b146608ef08b6d640b49763c8989a8dba803c2ddd01563c786492"
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
