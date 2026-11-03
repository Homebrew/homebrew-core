class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "https://github.com/terryyin/lizard"
  url "https://files.pythonhosted.org/packages/e6/67/0c5fe939ee37df57f415f4fe461a894ae12d18e9fea89705cbd2525967b6/lizard-1.25.0.tar.gz"
  sha256 "e37e0da72be4fd4a254f511470af2b2f6800128879844b2844695641baa83112"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9da0e3e234353f85f7eff379188c3aa99e96ab00beefc3892fedcc42d44bc2e2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "11dcb2625f4be83584630a0bd0325d4da68d9d7bd93596e11d2dfe95d4ac36f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5961ea783ea5b8ded1ceb510278a5deca916afb1bf4ead7a61901543a4ce3987"
    sha256 cellar: :any,                 arm64_linux:       "fd619207fb65d18ac0db61426858167a3c611c69e97eca590ba59ae2e03351b8"
    sha256 cellar: :any,                 x86_64_linux:      "8b5a71b3231f4743d6ffa6f2791c862ec445d1d133cd1f0f831f7195c3e12b61"
  end

  depends_on "python@3.15"

  conflicts_with "lizard", because: "both install `lizard` binaries"

  pypi_packages extra_packages: "jinja2"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
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

    output = shell_output("#{bin}/lizard --languages swift #{testpath}/test.swift")
    assert_match "1 file analyzed.", output
    html_output = shell_output("#{bin}/lizard --html --languages swift #{testpath}/test.swift")
    assert_match "<!DOCTYPE HTML PUBLIC", html_output
  end
end
