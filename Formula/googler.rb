class Googler < Formula
  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v3.5.tar.gz"
  sha256 "55ff07648257f5d2d642d1f5d6bd682e6aa32605755d4040dac4ef787257cbea"
  revision 1
  head "https://github.com/jarun/googler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4325937b3b156751c2ee51aed335c455f63236e45c38b28b079818a9a01c4bf" => :high_sierra
    sha256 "e4325937b3b156751c2ee51aed335c455f63236e45c38b28b079818a9a01c4bf" => :sierra
    sha256 "e4325937b3b156751c2ee51aed335c455f63236e45c38b28b079818a9a01c4bf" => :el_capitan
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
