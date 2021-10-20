class Ddgr < Formula
  include Language::Python::Shebang

  desc "DuckDuckGo from the terminal"
  homepage "https://github.com/jarun/ddgr"
  url "https://github.com/jarun/ddgr/archive/v1.9.tar.gz"
  sha256 "3dfe82fab649f1cec904a1de63f78692be329a3b6928c1615f22c76f6e21c36f"
  license "GPL-3.0"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eec5e7fe4cc40ceaba669038d3c7c7ff09ab6203eae500022555adccdf92e4ef"
  end

  depends_on "python@3.10"

  def install
    rewrite_shebang detected_python_shebang, "ddgr"
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "auto-completion/bash/ddgr-completion.bash"
    fish_completion.install "auto-completion/fish/ddgr.fish"
    zsh_completion.install "auto-completion/zsh/_ddgr"
  end

  test do
    ENV["PYTHONIOENCODING"] = "utf-8"
    assert_match "q:Homebrew", shell_output("#{bin}/ddgr --debug --noprompt Homebrew 2>&1")
  end
end
