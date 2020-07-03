class Ddgr < Formula
  include Language::Python::Shebang

  desc "DuckDuckGo from the terminal"
  homepage "https://github.com/jarun/ddgr"
  url "https://github.com/jarun/ddgr/archive/v1.8.1.tar.gz"
  sha256 "d223a3543866e44e4fb05df487bd3eb23d80debc95f116493ed5aad0d091149e"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba751df7de76dd4c286e8502cf5e46f406f1e6b1467689f98158bc92f7df42b2" => :catalina
    sha256 "ba751df7de76dd4c286e8502cf5e46f406f1e6b1467689f98158bc92f7df42b2" => :mojave
    sha256 "ba751df7de76dd4c286e8502cf5e46f406f1e6b1467689f98158bc92f7df42b2" => :high_sierra
  end

  depends_on "python@3.8"

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
