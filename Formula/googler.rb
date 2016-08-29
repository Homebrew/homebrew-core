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
    sha256 "9012b7678914b690069d0b89a2322ffbc394bdb0b8ea2c15a6bf8d07ab23a6e0" => :el_capitan
    sha256 "94842d1f7089f9a18c518ced907d1b789d93cc956b57c163279cf11f94542cda" => :yosemite
    sha256 "8c7bca96861a3501126d40b0678d28d174e89e503ddec0bfd88f690b2df85e7e" => :mavericks
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
