class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.23.tar.gz"
  sha256 "5ea8f3f23e523121cdb8cf576130de9a73e35636c231c50f4d6da75f6b27a715"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17f93f8503c155319178c2353ba8838fe6320cd0a9911093d94833edf864edfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d268241c74bbf7c241c6a528f863ff30b38ff20549873a7ef53326459c6dea5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7afa02439c859aa4975f088e11c57e71f62a26891c934879b346405a5fecccb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "9eebd81ffd77379e8522f76ade55cbe44e3bb48e344e35ad443576d119fa0c7a"
    sha256 cellar: :any_skip_relocation, ventura:       "ea8e70f83a0ede27deaa5cff90ed5e81b5ed81b1054a05a0c9f82568b1ad1560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a197f03b354035103ab748110566782a370a53c8429f9cece90a4cdeca875dfc"
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
