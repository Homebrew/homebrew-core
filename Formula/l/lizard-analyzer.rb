class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "https://github.com/terryyin/lizard"
  url "https://files.pythonhosted.org/packages/72/b1/47a2a3ca5aa0d57e8affeafaef79827e971dc448fb2b40b55708c81ebf62/lizard-1.26.1.tar.gz"
  sha256 "9a4d7372faa12dbe725cfb6dcadf9bed4916f9176a154b285917713012ac35c3"
  license "MIT"

  bottle do
    manifest_sha256 "fefa47dc2e54b37e33bf2cd6cc9f8143dd2814f3cca9b5bc82a08340b4e6ddeb"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "560b869733a216747c372c4ce5723a318fe4d8fd1b97e543c345cd5706341e57"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c3f5be283c5363c35c66a676599f5137b331ddee20c08f96427260d30310cd76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e67b8fd450751c887db1127355a806aa5cf1b2afb7c912f2d66e9724f2d7fce9"
    sha256 cellar: :any,                 arm64_linux:       "84f9e39ac0db7e8344be5cac7ebba5a89f6f8254bf255668b109dc78f87bdab2"
    sha256 cellar: :any,                 x86_64_linux:      "c2348caf4e9adda48438dbe40b270bb584f8f9d90662744b8c02934363f9ca31"
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
