class Brush < Formula
  desc "Bourne RUsty SHell (command interpreter)"
  homepage "https://github.com/reubeno/brush"
  url "https://github.com/reubeno/brush/archive/refs/tags/brush-shell-v0.3.0.tar.gz"
  sha256 "a0dac5cf7e9d8bced9bf28ed400955750ed6b7320d1154522a14f4a74e75a056"
  license "MIT"
  head "https://github.com/reubeno/brush.git", branch: "main"

  livecheck do
    url :stable
    regex(/brush-shell[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d62172c2f07ead104359fb3485595bec113dabc2b05e9dded3c2fb0ab80df9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ae28a423a3690aab0f163f6de5ebf15652f12cf5e11b7662e7c24095b021efd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8c2683da27ee0cbb7458651a9bd7b885650f8cf58d00e544b3b8f061f90f3b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1734ad8babbaaca852bdc04f3abb8f1bc79fac949d57a2e1d695ba16542d712c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33cc6f3f71341f1e34d73019448cb5d91f2563abbfcdc1b057df46f7ce82cedd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ab23f77499e85c5fbe70aaeffcb521bda4f053c5be4f21cc653e5c182291909"
  end

  depends_on "rust" => :build
  def install
    system "cargo", "install", *std_cargo_args(path: "brush-shell")
  end

  test do
    assert_match "brush", shell_output("#{bin}/brush --version")
    assert_equal "homebrew", shell_output("#{bin}/brush -c 'echo homebrew'").chomp
  end
end
