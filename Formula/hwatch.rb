class Hwatch < Formula
  desc "Modern alternative to the watch command"
  homepage "https://github.com/blacknon/hwatch"
  url "https://github.com/blacknon/hwatch/archive/refs/tags/0.3.7.tar.gz"
  sha256 "a7c7a7e5e2bddf9b59bd57966eaf65975bb3a247545c2be2374054f31aa0bcb8"
  license "MIT"
  head "https://github.com/blacknon/hwatch.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "909bd5f23d2595b342c0146d15ef96a854074c29f467316eeed5dc8474e086e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51da8da8a155e5e53aef542ed6868decf42d80f493eb6d183398b9333e800e47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fee41baa00015700821d842be4a8d9e763ac661e5ddd55bc7c965f0f4b5c3a1b"
    sha256 cellar: :any_skip_relocation, monterey:       "cbee54228e2414579971af594d05d2524340c67a222734e1d2b5a1fd9e2001b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0366e46f7d74c88ceca186d6d62fc881685c609053bb9d37be736cb4eefbca8"
    sha256 cellar: :any_skip_relocation, catalina:       "ae5492d7dce8f4ba9e44262268a1eb757425c5ccab8f50187f9e9c03ca4e989b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f4a0c4f09ceb91fed32fbc115daaabda60995d4afa1d1ea9cced599786c74db"
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
