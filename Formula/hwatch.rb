class Hwatch < Formula
  desc "Modern alternative to the watch command"
  homepage "https://github.com/blacknon/hwatch"
  url "https://github.com/blacknon/hwatch/archive/refs/tags/0.3.7.tar.gz"
  sha256 "a7c7a7e5e2bddf9b59bd57966eaf65975bb3a247545c2be2374054f31aa0bcb8"
  license "MIT"
  head "https://github.com/blacknon/hwatch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "207e32f2bbcb0178bf81c7901047fbd8a9ee5c348101d0a2680e61ed83838309"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41bde24420c67c60ab75f465401275b0d8424d20c191f02023f44c9d8e444b9f"
    sha256 cellar: :any_skip_relocation, monterey:       "7c2dbd52999f807c0a16e4714a9b0dd68f0d199c578cbd320a828593c1d7b2ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd278d2294ef73c5555e3ead67cb3006a3817e3791d41b637df58269ebb5f539"
    sha256 cellar: :any_skip_relocation, catalina:       "8c183292c7f3297fc53998ba9821a439d2a7834a2cba33bae6a198af242654d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e21942f63a34751f20e641d4c7c44f5f0e662fe2494ac0afb0b58f480ffd2dc3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/hwatch.1"
    bash_completion.install "completion/bash/hwatch-completion.bash" => "hwatch"
    zsh_completion.install "completion/zsh/_hwatch"
    fish_completion.install "completion/fish/hwatch.fish"
  end

  test do
    begin
      pid = fork do
        system bin/"hwatch", "--interval", "1", "date"
      end
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "hwatch #{version}", shell_output("#{bin}/hwatch --version")
  end
end
