class Exa < Formula
  desc "Modern replacement for 'ls'"
  homepage "https://the.exa.website"
  url "https://github.com/ogham/exa/archive/v0.6.0.tar.gz"
  sha256 "84cd6b3c389d5ec0483f8e438557d971897b5e1015d22a8cb3ae7558f87f4bf0"
  head "https://github.com/ogham/exa.git"

  bottle do
    cellar :any
    sha256 "cc41870a7afe46a6a5e038ed56693492c260539f7e13ada7d8dea3e4ee419584" => :sierra
    sha256 "486f82d87223f31e3e6c90fb417695fcf2a70264a22725159ab5cac715a25e1a" => :el_capitan
    sha256 "1340bee1fb729e88c299c82c41459033bc03175c6407ccbcf269d33a913f1e7a" => :yosemite
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
