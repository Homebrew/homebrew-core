class Googler < Formula
  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  head "https://github.com/jarun/googler.git"

  stable do
    url "https://github.com/jarun/googler/archive/v2.7.tar.gz"
    sha256 "ca9f3f2e7b475c458be8bb61f7b7b170d0d174c18c4afa8292e815dd9d5531a4"

    patch do
      url "https://github.com/jarun/googler/commit/6152bd3.patch"
      sha256 "ca16a5ed65aceeba8f079b0fbb0371d0755c30c5e43139ba1a659b2730944788"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "15aa5bcc9869993df207ccd661780493b78596729d6b0761a80c84cf58f99d4b" => :el_capitan
    sha256 "8f28be805f4d8c9dc43ad82533e9c4bba7fe3680ec136a0f849dab85768b2b11" => :yosemite
    sha256 "8f28be805f4d8c9dc43ad82533e9c4bba7fe3680ec136a0f849dab85768b2b11" => :mavericks
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
