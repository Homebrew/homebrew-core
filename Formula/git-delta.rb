class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.11.2.tar.gz"
  sha256 "7dff2a7cc69277b757c08c7398931cb13372458891f1dd992beb2dae8ee42411"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f8ae3a71fc314b8c2f1330c7b32f9e1beaba85fa9f428e204a4693eeb4c3802"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aebb2dece6ed693f2eae460ea7f393f262da3f952230461547fdd63e5e76447e"
    sha256 cellar: :any_skip_relocation, monterey:       "f70fbfc6789a9f3458d5ab705bb0624da39d9447483b64d5d365923e1a49bd33"
    sha256 cellar: :any_skip_relocation, big_sur:        "e254533ee1bdfbd5b8f25372fab55d8f7f5a675e4bdd011ca599aa5c3c55d71e"
    sha256 cellar: :any_skip_relocation, catalina:       "da82340a9a74a0398243f3a17e3dd140a14c520b449df7e1924519faeafb0446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22693902dc765777cc2f1f58832e5653ae0614576a2bd56b9870282f23160829"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  conflicts_with "delta", because: "both install a `delta` binary"

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "etc/completion/completion.bash" => "delta"
    zsh_completion.install "etc/completion/completion.zsh" => "_delta"
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
