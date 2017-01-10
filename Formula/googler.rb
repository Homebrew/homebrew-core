class Googler < Formula
  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v2.9.tar.gz"
  sha256 "71a992d3e6a3fcbe0edcc88fc389edf4ce4da97c3377d62cc3a7e5d512304504"
  head "https://github.com/jarun/googler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "44f9bd65915294fa8230db2752b873211140beba4257e6a74dd5f443dc664f68" => :sierra
    sha256 "94b3ac1de25be458fad9f89ce70d34b6c3dc2c52a4df067163e69e9251d85387" => :el_capitan
    sha256 "94b3ac1de25be458fad9f89ce70d34b6c3dc2c52a4df067163e69e9251d85387" => :yosemite
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
