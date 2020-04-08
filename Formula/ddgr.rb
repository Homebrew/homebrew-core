class Ddgr < Formula
  include Language::Python::Shebang

  desc "DuckDuckGo from the terminal"
  homepage "https://github.com/jarun/ddgr"
  url "https://github.com/jarun/ddgr/archive/v1.8.tar.gz"
  sha256 "882972441fcbcc94b52387e8ede8d3dd4e9dee47c83619b9d0b55357819682a9"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd46464d3817c39558827f8b1361d7fb895c420e45afc9ff11feeb6f27421531" => :catalina
    sha256 "830b85e70ba0fa714f536b270cc1ab4b32e248f546ccec8cb97e40e6c26448f8" => :mojave
    sha256 "830b85e70ba0fa714f536b270cc1ab4b32e248f546ccec8cb97e40e6c26448f8" => :high_sierra
    sha256 "a42b9e6ed21cbcc507eb01fa11ad1264b2e16e8a7f1b47c3b97d881d6ab145ab" => :sierra
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
    assert_match "Homebrew", shell_output("#{bin}/ddgr --noprompt Homebrew")
  end
end
