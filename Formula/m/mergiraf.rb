class Mergiraf < Formula
  desc "Syntax-aware git merge driver"
  homepage "https://mergiraf.org"
  url "https://codeberg.org/mergiraf/mergiraf/archive/v0.19.1.tar.gz"
  sha256 "36ccbbd80a3f79bdb23e9e087c9109aeaaed9cc80d85a7722c8db0c0295d107f"
  license "GPL-3.0-only"
  head "https://codeberg.org/mergiraf/mergiraf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6e24ba2ff071e80fcc71c2cfa32ad531f5c9babbda870ff10bcdf9308d8c381e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "accfe0cbe2ca8bf10090bf83b9232a408ff35a9bb8e0f9008f3eb24827973daf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ca8ddbe0d66b1d66ab6a4f20bbfb5da27b18adaa4d59e59d2d9efe933dd71817"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b48ec04e1ad7436573c642df2b7ccec3fa936365b662e0ee4242207d7dbf7811"
    sha256 cellar: :any,                 arm64_linux:       "5c0784a53cb4e153fb9a0b9e98f0f9c42ae7635d85a33cd5f341c853fabf78d3"
    sha256 cellar: :any,                 x86_64_linux:      "1644b1746e94668f297e6d7301cdb18d8d2e9112d78811319f12539c5c824ac8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mergiraf -V")

    assert_match "YAML (*.yml, *.yaml)", shell_output("#{bin}/mergiraf languages")
  end
end
