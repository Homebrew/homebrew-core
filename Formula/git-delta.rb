class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.10.1.tar.gz"
  sha256 "96feda5d979bdb2f3b747be1f6f05227e24ac20c0bfa95ead92f6a8b7de3b6a3"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47103c77f9d3636f615387729510dd3ef5f0b073b30e54527b7f69acd1c56727"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31617e6008d892603987884de960a0eef6fc15821c4b7adea21e95d91450e678"
    sha256 cellar: :any_skip_relocation, monterey:       "e87914140d2f40a839a30a0c5b649b762a52966b2648193a117bb8ff3fd787ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "0541dacf6c45eb93d86292f90cc4d72525a0ee6b138e3ef4b4c1fb201661c5bc"
    sha256 cellar: :any_skip_relocation, catalina:       "0d6297016b2fb70a00164b5b1eed6d4323575a64ccc1398d21fb6d8f38c4c703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aacf9437f73ba968a939fe167d11552af26a075f75c087e13f62b74a1e71fa29"
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
