class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.11.9.tar.gz"
  sha256 "9d17be4c9d733723da6bfd13417a5f73d0f6ea32802db6d94da8f377a4872b6d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3ea499c87e23aa0ccc4b09fab476cf4f024c7a22849746e1491c0f784a4c2f94"
    sha256 cellar: :any_skip_relocation, big_sur:       "6a5bcfed2d9478f408a731190ba0123834b3a26d46acfe8a0f3ff07371926a61"
    sha256 cellar: :any_skip_relocation, catalina:      "19c8493771d14e992c85103fbebade854e7099bc95013751468c077e42d8181e"
    sha256 cellar: :any_skip_relocation, mojave:        "a9d81106f9e8cb246dcf9ba80e102594e52b52f248d930c6e8b0b3443f021710"
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
