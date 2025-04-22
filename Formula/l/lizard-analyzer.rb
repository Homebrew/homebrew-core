class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "https://github.com/terryyin/lizard"
  url "https://files.pythonhosted.org/packages/2f/7b/68899dbce27f96b0f37aacca5148d12529e50aacbfaaf36233e01d08ba57/lizard-1.17.25.tar.gz"
  sha256 "942181fa78387cab15ce07201cd95ce5dec59a9259103bd489be941588bd3d41"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "65e5989915180cf70cabe3b18a971c681d10104f67069e634f6c97c810d85d58"
  end

  depends_on "python@3.13"

  conflicts_with "lizard", because: "both install `lizard` binaries"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

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
