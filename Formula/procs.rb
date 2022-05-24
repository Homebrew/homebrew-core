class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.12.2.tar.gz"
  sha256 "14be8440fe85dc46e544a3f7e89b887db455a61db981d5f75b91fd89b366d84f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5b63bdde580ec32e5cd98ed7c834694cee7e02e15d90975e3d8c975c442b803"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "919ce7c7c4ea83d07829926e12e1dcf3274b31a2fe5e13b839945a7ffde7ee19"
    sha256 cellar: :any_skip_relocation, monterey:       "b4ff9817d939b163b445a6c44952bb1c13c434f050e211751e57a43d680e7a75"
    sha256 cellar: :any_skip_relocation, big_sur:        "00c44bcd69bc8fec500febf137d20700f9abef4a33d2414b606749eed0e85c04"
    sha256 cellar: :any_skip_relocation, catalina:       "af3f308dbfc8fb4db0d2993a4356a8f3ea1ac892c00343ce9d7475929a6e9bdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afa0715a5f180622ac783fcbbbd4372f9d3b40abe7a714254f02a89567fc6d75"
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
