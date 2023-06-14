class Erdtree < Formula
  desc "Multi-threaded file-tree visualizer and disk usage analyzer"
  homepage "https://github.com/solidiquis/erdtree"
  url "https://github.com/solidiquis/erdtree/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "888d492c137e4c6a48a402860f4378d8a6eed3601a7c2c2b4e698ea97beb0d72"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da352af1497c4be836e7ed088b6679fcbf9f0d3f755ffe64d607e6c3e12cbcbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "706ff7c245c6906fa16d8298dec292baf8fefcaca4089bafd39d93cf474edc09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b8822940e34af24b32885c54c9ee37747613feedb788af4f6593a77a76a5b07"
    sha256 cellar: :any_skip_relocation, ventura:        "9732095e3170212ec3ad56533edab4c32a8fe00d4d9f76deef79d2c32b390ba0"
    sha256 cellar: :any_skip_relocation, monterey:       "e6c75fa7da25f2afa29855ca515be4767dce82f8b51e1497bd78df447244abd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c55f2844bf098534473be7fdf5b74557412b6da97f2f477e5b1dfb2a059b36f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b04ad1576bbf80f2ec70270ba0e87cfad746a4d89799343dca08d5b796514f0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"erd", "--completions")
  end

  test do
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}/erd")
  end
end
