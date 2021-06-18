class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/0.9.5.tar.gz"
  sha256 "f332ebb6c890e4e7b2bdb80a6324ecb4720890a2e53b4c178777e9537bbd4f54"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "718385d08918b314bc3adfcaaf735522091fe7c58b5cf87236adc7bef06cb4d1"
    sha256 cellar: :any_skip_relocation, big_sur:       "36de4c54b187328287bd5eeb899155039b7e6d2fa42d21311917c4d0b4f99700"
    sha256 cellar: :any_skip_relocation, catalina:      "2c85c0c2b65f4ba5939fcf934eb13e451c94a586b9bf4860711aee249c08d718"
    sha256 cellar: :any_skip_relocation, mojave:        "b1e420b3a06cc6dae414a65ad508ffd1488c765421810e84f07a8bbcd8708fa9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "man/just.1"
    bash_completion.install "completions/just.bash" => "just"
    fish_completion.install "completions/just.fish"
    zsh_completion.install "completions/just.zsh" => "_just"
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
