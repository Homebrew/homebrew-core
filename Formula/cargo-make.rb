class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https://github.com/sagiegurari/cargo-make"
  url "https://github.com/sagiegurari/cargo-make/archive/refs/tags/0.36.7.tar.gz"
  sha256 "acc3dabd6a30de8e5294bf002f6722d8efd51237dbf3a8f89696b81e26a6104e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9bb9684428b2db3c81474221abe77af145207c5cd312743ac3721bd066573d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f57aedbb834686d9412299506d1e8d65a5f4576054b3e3817340cf230f85d215"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e66acb7eaac0c01a3d04320b0172da07344cd32b4c03986a640814609dad75e"
    sha256 cellar: :any_skip_relocation, ventura:        "d60f30a6af00b653dee749ada8cd2fffe0f6967e99840a22b510635e45fbe03a"
    sha256 cellar: :any_skip_relocation, monterey:       "d1e9ae08f11d0b166d0327be3c231b59fd12182d64539411e747a24017f03e08"
    sha256 cellar: :any_skip_relocation, big_sur:        "f322f62c76b2f400aeeb3ace1fb7f9f03cf5452d0f27f2a0e256411b62daaafc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b029d87c51a727c390af7822b07a004282974f8589bba55f4ff085509f40cca4"
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
