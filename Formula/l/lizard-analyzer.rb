class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "https://github.com/terryyin/lizard"
  url "https://files.pythonhosted.org/packages/f1/80/39d0bcd64dbbb29ddb93ce294983e3fbaa0f92543e2025c3adad2580b91f/lizard-1.26.0.tar.gz"
  sha256 "0e522a6d9ee0ecf205ceca867e3ace2cf3189a0226320d52e4dacb40e8ede180"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0dbab00cca6f4722b4cd5f8b96c7fef74c292952f24a0eeb7a6a4d5af6a9785e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "17ba0b0096c6dea350cda350e0ce8565de5a7f5b0ac62ad69b29034cea88313a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a4d168fc8ee82f1a3ae9a7933dfcfb1fcb295dc7a0e2c39eddaf831d3c9ee282"
    sha256 cellar: :any,                 arm64_linux:       "35c8c3c7ffe0e9ca9b91c9d1591b69bf181533e724cc8e475bdb596a174e388c"
    sha256 cellar: :any,                 x86_64_linux:      "2769709478423ae1d2c4a3bd6617a765c83a2e4a9ec7cdb6108d42baa65e7581"
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
