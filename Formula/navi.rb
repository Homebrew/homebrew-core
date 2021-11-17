class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.18.0.tar.gz"
  sha256 "be36c9021a23c94b585e6dc328495a818dea7de6057572ab25858f45f95e2312"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a98cd907cb703e14415184756c95a52cf42db15988739eede87684e3b8101c53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3b36aa7c488a07b220fd3fd67486abfe809dfdd1a9fb875c7e4fbb2743d0f9b"
    sha256 cellar: :any_skip_relocation, monterey:       "8bce2c66836b2334361bdf7b170b151ead985e43c8a217108be7b05afb342a9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbd0b97113f8078e6f6c3b80149434acb546412ed91b4dcd4cb8d6bde8b8e0c6"
    sha256 cellar: :any_skip_relocation, catalina:       "85af823e9734ab9e1ab8800fb92eefae41e37a7b7ba48ef1278b39d48cd223f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ee5fe8a6abbb07f0d784f798e33693d2ef6c51392c4b384d6c54e6d1d085e70"
  end

  depends_on "rust" => :build
  depends_on "fzf"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "navi " + version, shell_output("#{bin}/navi --version")
    (testpath/"cheats/test.cheat").write "% test\n\n# foo\necho bar\n\n# lorem\necho ipsum\n"
    assert_match "bar",
        shell_output("export RUST_BACKTRACE=1; #{bin}/navi --path #{testpath}/cheats --query foo --best-match")
  end
end
