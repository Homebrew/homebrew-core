class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/refs/tags/0.18.2.tar.gz"
  sha256 "64717c3b3335b44a252b8e99713e080cbf7944308b96252bc175317b10004f02"
  license "MIT"
  head "https://github.com/dandavison/delta.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3a1b1cbdf4f259177acc02665a5827c38320f5b804fa391e08a24c2be1ebb97c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f378ac5677c7f9ddf54b72005c06fb7cb86b73777aec514085499d82de7bc7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f54682cb0774ae38169bc4352fef7633705824cf2803ea8a5d4c9a7c5543b83a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d60b437ccc71fe14bc47632bcb02c17454977a837bbf44352d7081cd8ad0e5fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "a000e15fea6bf6df0b6f4dfb2b453083f78b4b0095eb7151d30031379b0b881c"
    sha256 cellar: :any_skip_relocation, ventura:        "a22b94c2c7a3a384f9308ee31b3248b51d89081f31c3837d35ebb24893de723a"
    sha256 cellar: :any_skip_relocation, monterey:       "2224845754676513a29dd5e2994cff7e92d2fa83089db6ccaa56d82ffe41ac85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b316e9346c30445375c522e5cceee0dc058c6168ff659257b02b3e893d6b997"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "etc/completion/completion.bash" => "delta"
    fish_completion.install "etc/completion/completion.fish" => "delta.fish"
    zsh_completion.install "etc/completion/completion.zsh" => "_delta"
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
