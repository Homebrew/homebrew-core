class Ddgr < Formula
  include Language::Python::Shebang

  desc "DuckDuckGo from the terminal"
  homepage "https://github.com/jarun/ddgr"
  url "https://github.com/jarun/ddgr/archive/v2.1.tar.gz"
  sha256 "fb6601ad533f2925d2d6299ab9e6dd48da0b75e99ef9ed9068f37e516380b5e6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "42d0db350134ea8a82afadbca7d18f9f234996621481b65f2576d83a96a0c689"
  end

  depends_on "python@3.11"

  def install
    rewrite_shebang detected_python_shebang, "ddgr"
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "auto-completion/bash/ddgr-completion.bash" => "ddgr"
    fish_completion.install "auto-completion/fish/ddgr.fish"
    zsh_completion.install "auto-completion/zsh/_ddgr"
  end

  test do
    ENV["PYTHONIOENCODING"] = "utf-8"
    assert_match "q:Homebrew", shell_output("#{bin}/ddgr --debug --noprompt Homebrew 2>&1")
  end
end
