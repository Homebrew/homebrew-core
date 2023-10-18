class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.14.1.tar.gz"
  sha256 "bb4f9d696081807ca105593092f8acd04ca339ae43fff29e0e820c6fc5e3f9ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aed3cc37118c7fdbd54fca6343e9ee7ac77274890b9c91824290f3f398c30f10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3beb7a6134bfa0b8b698bcaebccebeb8a7192d03cd9024a9f9cf15bb4b8f59e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1585f910cf357820e8d0806570f804add17364594721b7ea8cfde6fc43d5ff3"
    sha256 cellar: :any_skip_relocation, sonoma:         "72187ef1363193bd94cacee7de46d6b23b25401dd543e016063e7e8fa4811f81"
    sha256 cellar: :any_skip_relocation, ventura:        "3060dc5ced32b3039eed1e81ed728ede2513937bebd4d7d95e2c228863ac49b9"
    sha256 cellar: :any_skip_relocation, monterey:       "5ab597ead5557702b71b2aaf3de7bebfb4046783a196336881356e7bcc5c1038"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3da478ec1b1f5bb72e94b9de283977dc5f14a5c678bcc52e3ba303669e7d0f1a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    system bin/"procs", "--gen-completion", "bash"
    system bin/"procs", "--gen-completion", "fish"
    system bin/"procs", "--gen-completion", "zsh"
    bash_completion.install "procs.bash" => "procs"
    fish_completion.install "procs.fish"
    zsh_completion.install "_procs"
  end

  test do
    output = shell_output(bin/"procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
