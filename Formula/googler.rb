class Googler < Formula
  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v2.8.tar.gz"
  sha256 "5a9a128180992c0f6b6b7f0bd9d13191cd83cf56ff7e185fcb0e48e79740b355"
  head "https://github.com/jarun/googler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a515db8b4fe8c240d984ae6605e78c0eac54ed37c8f588bf8d863ba7cc8ad54b" => :sierra
    sha256 "a515db8b4fe8c240d984ae6605e78c0eac54ed37c8f588bf8d863ba7cc8ad54b" => :el_capitan
    sha256 "a515db8b4fe8c240d984ae6605e78c0eac54ed37c8f588bf8d863ba7cc8ad54b" => :yosemite
  end

  depends_on :python3

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
