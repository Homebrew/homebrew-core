class Exa < Formula
  desc "Modern replacement for 'ls'"
  homepage "https://the.exa.website"
  url "https://github.com/ogham/exa/archive/v0.8.0.tar.gz"
  sha256 "07085fd784d553b7c3b62b5a52e4635580d6154f47e6d64245ec0588638dee3e"
  head "https://github.com/ogham/exa.git"

  bottle do
    rebuild 1
    sha256 "b401bbba34d24a248b9a91d43caa383130ed2dd1b50f15cb2329fc0b1ca3e72a" => :mojave
    sha256 "f06c486a62647baef664ef2c83e9437a1b38d125f59bed2a15b6262ce6bc91bb" => :high_sierra
    sha256 "a04e116ccd0751fa1d1ef21d3118d263387bfb54eebf73a01d827d90712003ad" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"

    bash_completion.install "contrib/completions.bash" => "exa"
    zsh_completion.install  "contrib/completions.zsh"  => "_exa"
    fish_completion.install "contrib/completions.fish" => "exa.fish"
  end

  test do
    (testpath/"test.txt").write("")
    assert_match "test.txt", shell_output("#{bin}/exa")
  end
end
