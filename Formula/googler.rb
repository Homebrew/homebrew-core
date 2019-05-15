class Googler < Formula
  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v3.8.tar.gz"
  sha256 "d942392a6bc3faee44951e2069b547b401bb688b2368f3a4385bb3ca7b6efa0f"
  head "https://github.com/jarun/googler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f0c0dc656e7ad4aaebf188532ebe3ea694eb38410811e0f84d220f1c9fd5ad7" => :mojave
    sha256 "4f0c0dc656e7ad4aaebf188532ebe3ea694eb38410811e0f84d220f1c9fd5ad7" => :high_sierra
    sha256 "a7a5a6d41c5a604d76c26d0dfc5030b29ef5a678a7384c331bd8be4f208e7018" => :sierra
  end

  depends_on "python"

  def install
    system "make", "disable-self-upgrade"
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "auto-completion/bash/googler-completion.bash"
    fish_completion.install "auto-completion/fish/googler.fish"
    zsh_completion.install "auto-completion/zsh/_googler"
  end

  test do
    ENV["PYTHONIOENCODING"] = "utf-8"
    assert_match "Homebrew", shell_output("#{bin}/googler --noprompt Homebrew")
  end
end
