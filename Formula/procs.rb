class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.14.0.tar.gz"
  sha256 "fa5af0951dc8aa63c0590f8c5c1136594866057704cfb1cdfc22ac3cc49437c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce5c4fbef3d298de789442018ecd415726928035cbdd97a4dd22be9728ff701c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acd6917f8c30de7074ebfc9c70815472f8d29d57202543f038ca2ad06ee22694"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e64e47b40f5cb0a363b25a53e05324529c843cb777840d79487bf31ca89b66f7"
    sha256 cellar: :any_skip_relocation, ventura:        "7307978d50f2dc5802157a4194224ebaf73c282b5096d8de54adbd0e7ab29693"
    sha256 cellar: :any_skip_relocation, monterey:       "4a74cb9aeda845a964ccdfa80b71added1b7d39d28d9362c188a2c0c040bd743"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e7be029b6f52540b22158852cb6e7802dc6a6f708ce8acd1f3078c60c3dd358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a75396bb0024bfe05a2c925ef6a451a33cf18d38f5ced33d6b26809648a5223"
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
