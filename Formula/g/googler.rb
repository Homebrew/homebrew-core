class Googler < Formula
  include Language::Python::Shebang

  desc "Google Search and News from the command-line"
  homepage "https://github.com/oksiquatzel/googler"
  url "https://github.com/oksiquatzel/googler/archive/refs/tags/v4.3.13.tar.gz"
  sha256 "5d887f49ca2a83f8ecb87e505dfdb32d228a5b2e0d3bdd77b4722fc864085e57"
  license "GPL-3.0-or-later"
  head "https://github.com/oksiquatzel/googler.git", branch: "main"

  depends_on "python@3.12"

  def install
    rewrite_shebang detected_python_shebang, "googler"
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
