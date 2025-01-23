class Monocle < Formula
  desc "See through all BGP data with a monocle"
  homepage "https://github.com/bgpkit/monocle"
  url "https://github.com/bgpkit/monocle/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "6375214d15f780e2e54320841a00d13330d5a1b998a7df357a309b8877d20780"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6071056a263f14da10efa8b636a62c6553f4cc06b26f0684c624b041d29036f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a23a54bf278b3f5232a451b2fd3a79c390971d7b84f4fa98e27e732a8775536"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1444eccd36ed182eecd0f0a6c7af8c779185c44cf07f3351a67b3e919e5d5dfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "d86179ca68b5d3070856042e857d0f50d76c67c6600393b71ebf1a1c424ba31e"
    sha256 cellar: :any_skip_relocation, ventura:       "3a1696c31a32db8138617cf9c55470c25b385c800e3558a902304a4cf191abff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc632d35fa157dc4009323bdc998ea2f5ed267242bc5216f1fc00b6841592035"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/monocle time 1735322400 --simple")
    assert_match "2024-12-27T18:00:00+00:00", output
  end
end
