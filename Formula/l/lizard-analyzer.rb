class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "https://github.com/terryyin/lizard"
  url "https://files.pythonhosted.org/packages/5b/94/4967d0868e7db39a72fa2dbef9a798c4d661178f3836bfec58091606f0f3/lizard-1.23.0.tar.gz"
  sha256 "ed75cd45f086a2f51d6be64b0149b71bda820f92f95e30898254528bb949f795"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf1aa9b4f777ad52961f55430c39f8455c04963127e5275d5c19c09cd7a0a0fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30a87d7d8d0ca0d4e7eaf9301dd48ffcce692d5734575a69393bdcf1d100d537"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc5a2b75321d54efd4d73b538b824dbd5da410077711a05e53f15af598caabbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "16e18661fb1b18a9a0a78605c426dfbb0941a9d2ed20e9faaefd1b878f2e73d1"
    sha256 cellar: :any,                 arm64_linux:   "a58e605483938f8836a0331ad36849bc9de85cc04ea9178b6280c7ce3a674570"
    sha256 cellar: :any,                 x86_64_linux:  "786e725a906e69a7bf05e4ee71bcafb4725b639004084dc4a82905e28f6e76e7"
  end

  depends_on "python@3.14"

  conflicts_with "lizard", because: "both install `lizard` binaries"

  pypi_packages extra_packages: "jinja2"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
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
