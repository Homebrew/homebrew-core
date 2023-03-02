class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https://github.com/sagiegurari/cargo-make"
  url "https://github.com/sagiegurari/cargo-make/archive/refs/tags/0.36.6.tar.gz"
  sha256 "58d3347f2c2f0d32717286e0fa98bfed8fbe77b3865fcd1e4e864927c2682db1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2f97a86a39d94d01156a099e607b37ceeae0d70942f2f0602e7c5a01d3648f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24dfd6636b2841a16e11ecf4921a2c5f727232742b125934b4bf585772eb1f15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c2bfd59c935094951cde65c7016389b87040bdb62e7076b4d50f41e780f09fb"
    sha256 cellar: :any_skip_relocation, ventura:        "718b8bcd5b7464a0248ab3aaf8df602bb7b81fe073db66a1ef5b43ea1b6a863d"
    sha256 cellar: :any_skip_relocation, monterey:       "b1467d88dbb5640b5339d31577f015c7d82566f076779bbc46068107106b7538"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7f91f7a3d093a0b061f0fb7dd45fa21cd8b90dd8c246055cd295fefc72bc6b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc3d4077f35c2d7dd8a9940a95cc010982b38fe729e0c1371a7bdb369ce69a29"
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
