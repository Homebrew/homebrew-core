class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/refs/tags/v0.14.5.tar.gz"
  sha256 "539b88565c775a106063da5cc5148cfdc7e010534f3dbc90cb8f6317d51ca96b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c50c8c9993e9e254e0a638322f540cf215d71af4831859cc4379223b1c42f37f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09b2ea2aabfef2c0382917fbac42cfa5c23491304d075140d593ba697518f0d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19441d5ac8b5208a5a03d8d24fe54d2d3f17c6e3df9426021f6395fbf96a86a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "a27c2a9e22fb20ff4cf9901df051e8fb868a1289a46f6134f9bcbee7a4a715ff"
    sha256 cellar: :any_skip_relocation, ventura:        "10d7a2d18c3a906bb35ee581f2d7360a2f40129d2d4d7bf18d7269391557582c"
    sha256 cellar: :any_skip_relocation, monterey:       "daa0a5d0d181ae6ac377b314f875ae07eb8519832bd99f738284a38cf84529c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "033f5c477327598219b333b9cf0b38861ae9a38f2b4e5c85046ea58b0cb99dee"
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
