class Ddgr < Formula
  desc "DuckDuckGo from the terminal"
  homepage "https://github.com/jarun/ddgr"
  url "https://github.com/jarun/ddgr/archive/v1.4.tar.gz"
  sha256 "045063b4d7262992a7ea3cd9fe9715a199318828de82073f54c42631d3ef41b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "82adec1f9d44f702dda20a4099e396b98f4bfcf876a238fa1eeb102f5dd7c86b" => :mojave
    sha256 "1fcc37ddba0118645c78282e191b7c13568e40e72c07c69366223e1656310845" => :high_sierra
    sha256 "1fcc37ddba0118645c78282e191b7c13568e40e72c07c69366223e1656310845" => :sierra
    sha256 "1fcc37ddba0118645c78282e191b7c13568e40e72c07c69366223e1656310845" => :el_capitan
  end

  depends_on "python"

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
