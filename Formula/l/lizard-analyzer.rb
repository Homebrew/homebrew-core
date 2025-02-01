class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "http://www.lizard.ws"
  url "https://files.pythonhosted.org/packages/9d/a6/3597da70af0966c06ff2a7c2aec837651c3c535e4c2cc0f67a4f4e71c11f/lizard-1.17.14.tar.gz"
  sha256 "31d869da4701e8a9fff6d20e4459ed205ebf398666d046eb496266a0cc3b0497"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6521c49c07c06ed13bb10511826d29978353fcb5c388d590ee373e049992c91e"
  end

  depends_on "python@3.13"

  conflicts_with "lizard", because: "both install `lizard` binaries"

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.swift").write <<~SWIFT
      let base = 2
      let exponent_inner = 3
      let exponent_outer = 4
      var answer = 1

      for _ in 1...exponent_outer {
        for _ in 1...exponent_inner {
          answer *= base
        }
      }
    SWIFT

    assert_match "1 file analyzed.", shell_output("#{bin}/lizard -l swift #{testpath}/test.swift")
  end
end
