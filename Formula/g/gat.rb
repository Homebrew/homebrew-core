class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "303db5afd45b802946ba88a10f37bc28ab03b9f2a524cb0a053122e5e92a0b4d"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    manifest_sha256 "80305fe9020798ac0c9f3abfd1ee403cf5e45b09a3540b036205f218dac05dfd"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bb638a1757f616e7160b63ba2027c1749f3b26d35f2b5905f5236d7a79d9d2e7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bb638a1757f616e7160b63ba2027c1749f3b26d35f2b5905f5236d7a79d9d2e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bb638a1757f616e7160b63ba2027c1749f3b26d35f2b5905f5236d7a79d9d2e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ed524515a6cefe4044b3347d2010d9c5d3f9fdf5e36acb17a41b2c429b9953ac"
    sha256 cellar: :any,                 x86_64_linux:      "52e7be0b91ff45ccd89ed2fe2017262b2788100a776bf2d337f8aabec7b3b366"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/koki-develop/gat/cmd.version=v#{version}")
    generate_completions_from_executable(bin/"gat", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end
