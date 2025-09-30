class Badkeys < Formula
  include Language::Python::Virtualenv

  desc "Tool to find common vulnerabilities in cryptographic public keys"
  homepage "https://badkeys.info"
  url "https://files.pythonhosted.org/packages/55/db/bc7583f7f0ed8effe33c20c0f4190b7167ae25a81641d8670a9e3ecb7adc/badkeys-0.0.14.tar.gz"
  sha256 "5eec8c646e90e1f8f64115ee9ea120d6886a231aae7d619017506f8cc630f48d"
  license "MIT"
  head "https://github.com/badkeys/badkeys.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eb836ec8e62ce944200bc75d60ce028cf84933d4543da2ed6c18edd0d700be1b"
    sha256 cellar: :any,                 arm64_sequoia: "d9b93cdd512c2261bafb082c9811eaa3bbbb7b745a3b3032bb1fb6586da0be8c"
    sha256 cellar: :any,                 arm64_sonoma:  "374d015560e5a086b8a25b850910fcaa6f446a4acd06b2a4a2335fb3aa9d1cb1"
    sha256 cellar: :any,                 arm64_ventura: "f829a4ec2607d8a5bec5abed89c493810d23b313016f50037b4c9ca0ba3e32a9"
    sha256 cellar: :any,                 sonoma:        "cd8c18499d61964fc953313888570c88285344aa2cf422507b73259bd91a1154"
    sha256 cellar: :any,                 ventura:       "9669beff92409b650fa0da71c4ffe4fb85263456aac0733e942ad0e62c69378b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b144bd3666e2c5ee61dfc94996aa29dc207c700381052409146d309226a476c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ed17a1fbc143891f5abe5ef698124310c3c10813fd81932f0a6e50a6d3521c5"
  end

  depends_on "cryptography"
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "python@3.13"

  resource "gmpy2" do
    url "https://files.pythonhosted.org/packages/07/bd/c6c154ce734a3e6187871b323297d8e5f3bdf9feaafc5212381538bc19e4/gmpy2-2.2.1.tar.gz"
    sha256 "e83e07567441b78cb87544910cb3cc4fe94e7da987e93ef7622e76fb96650432"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/badkeys --update-bl")
    assert_match "Writing new badkeysdata.json...", output

    # taken from https://raw.githubusercontent.com/badkeys/badkeys/main/tests/data/rsa-debianweak.key
    (testpath/"rsa-debianweak.key").write <<~EOS
      -----BEGIN RSA PUBLIC KEY-----
      MIIBCgKCAQEAwJZTDExKND/DiP+LbhTIi2F0hZZt0PdX897LLwPf3+b1GOCUj1OH
      BZvVqhJPJtOPE53W68I0NgVhaJdY6bFOA/cUUIFnN0y/ZOJOJsPNle1aXQTjxAS+
      FXu4CQ6a2pzcU+9+gGwed7XxAkIVCiTprfmRCI2vIKdb61S8kf5D3YdVRH/Tq977
      nxyYeosEGYJFBOIT+N0mqca37S8hA9hCJyD3p0AM40dD5M5ARAxpAT7+oqOXkPzf
      zLtCTaHYJK3+WAce121Br4NuQJPqYPVxniUPohT4YxFTqB7vwX2C4/gZ2ldpHtlg
      JVAHT96nOsnlz+EPa5GtwxtALD43CwOlWQIDAQAB
      -----END RSA PUBLIC KEY-----
    EOS

    output = shell_output("#{bin}/badkeys #{testpath}/rsa-debianweak.key")
    assert_match "blocklist/debianssl vulnerability, rsa[2048], #{testpath}/rsa-debianweak.key", output
  end
end
