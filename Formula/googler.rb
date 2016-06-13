class Googler < Formula
  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v2.5.1.tar.gz"
  sha256 "203dabbe6533cd66f8bbc6d4b93f691670086412dbad4879904c9f40ffcfa315"
  head "https://github.com/jarun/googler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "41e0ec94cc348ee3078a0b29f8e328d05866a74c69261ea8b10c559f2e0fe6d9" => :el_capitan
    sha256 "7c15188176d4d4389d7775da621ec13fc6a38860bc15352fe749ba0a09927b5b" => :yosemite
    sha256 "71bfac5cfdac269170b4c073059629b090181c969542829f8ca683b0bac19b52" => :mavericks
  end

  depends_on :python3

  def install
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "auto-completion/bash/googler-completion.bash"
    fish_completion.install "auto-completion/fish/googler.fish"
    zsh_completion.install "auto-completion/zsh/_googler"
  end

  test do
    ENV["PYTHONIOENCODING"] = "utf-8"
    assert_match /Homebrew/, shell_output("#{bin}/googler --noprompt Homebrew")
  end
end
