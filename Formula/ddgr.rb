class Ddgr < Formula
  desc "DuckDuckGo from the terminal"
  homepage "https://github.com/jarun/ddgr"
  url "https://github.com/jarun/ddgr/archive/v1.2.tar.gz"
  sha256 "a9828b8863949dc93dd574a15b6779d9390b6f5e277e35c157064d7c06423758"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "f0ec88b48600ba5e744e11e3cd943f0b92525052d2de0b660feeb1eed4b575d4" => :high_sierra
    sha256 "f0ec88b48600ba5e744e11e3cd943f0b92525052d2de0b660feeb1eed4b575d4" => :sierra
    sha256 "f0ec88b48600ba5e744e11e3cd943f0b92525052d2de0b660feeb1eed4b575d4" => :el_capitan
  end

  depends_on "python3"

  def install
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
