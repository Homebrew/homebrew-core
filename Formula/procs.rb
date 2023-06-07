class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.14.0.tar.gz"
  sha256 "fa5af0951dc8aa63c0590f8c5c1136594866057704cfb1cdfc22ac3cc49437c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de9c1631762b37a015ef29105948b0d16e040f114d771fc7cebe1f7c8c1ec27c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43df9e9c419a6746dfa675e4950aa00785d628179e8c01966620970f770e391a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d51c5e8f70fd83cf4b83586ac4a5a33a97b68850948b905064ede175a869e25"
    sha256 cellar: :any_skip_relocation, ventura:        "b2358cc32f33927686a09fc9fb380487fde56f79add118fb7d36848bbf8af29f"
    sha256 cellar: :any_skip_relocation, monterey:       "883c61ba9506ab4540781a29b7c0f5e0cbce671d7712be64b21ece718ff42090"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f221df219dbf0dc1736132cf9c96b1b7ac6bde0fbd397711b8a50e3503294ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90e02932ce2bedda3120384fdea912f82188f05170b341d7a9a2b8455bae10c8"
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
