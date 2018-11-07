class Googler < Formula
  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v3.7.1.tar.gz"
  sha256 "1ceadab40fea49a113f46807a5c7297fcf145eeaa8128e33d53aadb275377f37"
  head "https://github.com/jarun/googler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6165de5e7b9adfd53e7575723e3d817acff8ce56b1c067a9d7dbdb836dc72491" => :mojave
    sha256 "d44b89bb684a81fcb8a81cabec5f1761747acfa4b11a0be34cd8f22151499240" => :high_sierra
    sha256 "d44b89bb684a81fcb8a81cabec5f1761747acfa4b11a0be34cd8f22151499240" => :sierra
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
