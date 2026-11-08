class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "https://github.com/terryyin/lizard"
  url "https://files.pythonhosted.org/packages/ea/3f/3c0d1f57babf296a2833596fc2f6a82c0b85d4980d4bdc2e46148b5e2fe9/lizard-1.25.1.tar.gz"
  sha256 "3513ce263d17ed580f8efa202658b02c684d5da2b39ef40c7663971be822a9d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4683fb918138a7bd01e93f4ffe9dcfeab068a6a2cb7c319489ab4580d15be32d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ff60f37c9b813486df4ac1fb8c7a93f22eca4eb76921f12bf82eeab01b3a79cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c2526c7c5d44cbe570284926b84d600b3200ea976a98d21bc2f0abdaa45243e3"
    sha256 cellar: :any,                 arm64_linux:       "48e7d3dc0e57cafee9e26f1d549f530677e14f0d9e9f2dd087726ba636053b1e"
    sha256 cellar: :any,                 x86_64_linux:      "90d81f2c573081b4fa173d3d2f3f0746a13da58b094e3a2cf5a2ebe9ccdbfee1"
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
