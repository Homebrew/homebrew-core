class Ddgr < Formula
  include Language::Python::Shebang

  desc "DuckDuckGo from the terminal"
  homepage "https://github.com/jarun/ddgr"
  url "https://github.com/jarun/ddgr/archive/v1.9.tar.gz"
  sha256 "3dfe82fab649f1cec904a1de63f78692be329a3b6928c1615f22c76f6e21c36f"
  license "GPL-3.0"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "2e072910ed4e40203156efec17ffd926142f1dcbe452ee975f7bda67bf658e67" => :catalina
    sha256 "e790e6a0175047496f3b81e1226e4e55a1047c9b070dd18ffcd6825d17e840dd" => :mojave
    sha256 "57266892ebb4fe452b375f06ad756426eecbe7f144e4c6b79673cfce289d34fc" => :high_sierra
  end

  depends_on "python@3.9"

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
