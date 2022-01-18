class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.12.0.tar.gz"
  sha256 "04dbb3ddc734a9d1305b26b546a913e3e04d556b5863212a2675d29268aebed3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b92b2506e5cf32077b14e38d0dac5d2ad756ed9927ffb8eb083effd48efa7b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b413da16eb41b95d00b4be9ce9d695ee209cb0a26d17fbd53b7a248ac44f6ce"
    sha256 cellar: :any_skip_relocation, monterey:       "2f77a0b1a297cfd285cf0ca18613d2abe3f9b9b434336ce8dc20d2d4f7859198"
    sha256 cellar: :any_skip_relocation, big_sur:        "882f1f5bd30ccc04ea69c495c511d027438d69d240db2cb119499c404f1305e2"
    sha256 cellar: :any_skip_relocation, catalina:       "d6612fb938d33a4f256ec224ac81aeb6c3cf3711b6e5be757cf9ba0a8e41f33a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2aeae22ea856e44714db1af2c41232edf143899c7cb9ec9fcea25e0dc767ec1a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    system bin/"procs", "--completion", "bash"
    system bin/"procs", "--completion", "fish"
    system bin/"procs", "--completion", "zsh"
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
