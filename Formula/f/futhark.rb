class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.26.4.tar.gz"
  sha256 "a9f82dccfdf2cb1a5c4938e743d682ebf3a5bc69e43f28474a8e581caeb53136"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "1e3439c5649edd2353fde2aa9155d73cd1bdc6677a58c906a0b128dc81a1ef5d"
    sha256 cellar: :any, arm64_sequoia: "ea0f11c2d9145dde4916ae5e0981cb73c363e5c6b72c1fb48ff617d28db1e089"
    sha256 cellar: :any, arm64_sonoma:  "40ddb651ef8c43a9f60e47cc8bc930b23d8dcc61e729391174cadc0b03d28553"
    sha256 cellar: :any, sonoma:        "c7c9e48daee77db4e7673788b6a74d7b644d8db57ac6e70b195b541a3c300176"
    sha256 cellar: :any, arm64_linux:   "630d8ab6cc489445d4de0b31f9ccca929870cb95ca4e219dcdc8c54009ee0655"
    sha256 cellar: :any, x86_64_linux:  "e776663c3ed732be6ea19b521268b6ba79e124efc094cc5b76dfe446d5169a06"
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
