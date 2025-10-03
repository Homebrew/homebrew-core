class Procs < Formula
  desc "Modern replacement for ps written in Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/refs/tags/v0.14.10.tar.gz"
  sha256 "7b287ac253fd1d202b0ea6a9a8ba2ed97598cf8e7dfd539bd40e382c6dc6d350"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b1f2b86cdce127a951ea878549dec3d11cff8963480fe09fba395af42366444"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5049a80b8fe8d23bbee453de47cbb4347b0d56c173b7a4cfd29b76a7ebc4a900"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69ffb28f79ffd46055d4ce1a4f98628430d65114cf72d7c329735ea3ec963290"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cafbe79fabf8648fb1914aab023f3a3444266adda84a92284db37a6ef4d3e393"
    sha256 cellar: :any_skip_relocation, sonoma:        "009fa13890972f60741b94dc2f3fdb9de285c2dbf1bbb82a5d0a3fa30ad72b0a"
    sha256 cellar: :any_skip_relocation, ventura:       "a714f28f239c2b5ec662cfbaadc61203680de5ac0f090841960dc1617e8dfcec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a756c3aec5df02f365d8a7a42372bc461b9f80132328f6041b299fde1a3d1af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "343a27e3b76e161887adc165e9867a8b639d6def4d3d65757c7d2dae91ac76c3"
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
