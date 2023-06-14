class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https://github.com/sagiegurari/cargo-make"
  url "https://github.com/sagiegurari/cargo-make/archive/refs/tags/0.36.10.tar.gz"
  sha256 "ad85acc7110a2e22d23376e05d39c6dcb3bad7b414b2a3c0f46c656a3ac8ac1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78be892292d1f57087b44d16eab54dfcda29d519aefe71713ae318f1cc4b501e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e13b92cf978ebda160350adbd2880c708503dffdf75a715cc212f84c9bab1cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "710fb7597f7d6c55b55752b6ec29ff5c27eadb73645e5ff8269911492e7ab290"
    sha256 cellar: :any_skip_relocation, ventura:        "8a173a4efbb12b14ed29984ce835e3ad7a053aeb68e045ffff127567139fc595"
    sha256 cellar: :any_skip_relocation, monterey:       "e345c45363ee3b17480d8fd8e0f24049a375b58b1fa5c0b576a025bdc10acad1"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ae21c6654a10111ead076556b51f6763a48d2db8abc099cf59089efb0250389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed793d7bba9e7b86f7ce8072aee8f33d1602fbdf1d77efd77f92a98201ecccb9"
  end

  depends_on "rust" # uses `cargo` at runtime

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    text = "it's working!"
    (testpath/"Makefile.toml").write <<~EOF
      [tasks.is_working]
      command = "echo"
      args = ["#{text}"]
    EOF

    assert_match text, shell_output("cargo make is_working")
    assert_match text, shell_output("#{bin}/cargo-make make is_working")
    assert_match text, shell_output("#{bin}/makers is_working")
  end
end
