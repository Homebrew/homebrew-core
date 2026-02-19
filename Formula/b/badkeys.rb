class Badkeys < Formula
  include Language::Python::Virtualenv

  desc "Tool to find common vulnerabilities in cryptographic public keys"
  homepage "https://badkeys.info"
  url "https://files.pythonhosted.org/packages/5b/b8/9c5fdec4eb0b0a8b2e6a5a7a2d6da0fa5a905601a5e6a8c1f2aecb22f5c7/badkeys-0.0.17.tar.gz"
  sha256 "5562f2276a0343c5cfa5ecc54dc0e658e1b65fd36016858c04af9f33f7e9f826"
  license "MIT"
  head "https://github.com/badkeys/badkeys.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ff514f83c3e336777e658ed4113ae33d55003a5ea623aa3ace810e94fa9d00fe"
    sha256 cellar: :any,                 arm64_sequoia: "bfb4ee029aa483e8e65bfe142d9b8a69587fad6fd7e81a4152d62e635e506a95"
    sha256 cellar: :any,                 arm64_sonoma:  "65f571cbfb9b3f9a5b7152bce08edfb7f4b794a317636d24e9b6d4c0c1b592ac"
    sha256 cellar: :any,                 sonoma:        "c4d385ff9e584c3289891e8eb78f4b35158995da701895458ff8e9fab6d4b0d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "342bf80dcfc695ac6fe4ee708ebad245ed26211cd4bbba4345b262d20ecc8680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "449c92c21e80fed4714358834e26b652047fdd9865bf75c53e8f494328f0afac"
  end

  depends_on "cryptography" => :no_linkage
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "cryptography"

  resource "gmpy2" do
    url "https://files.pythonhosted.org/packages/57/57/86fd2ed7722cddfc7b1aa87cc768ef89944aa759b019595765aff5ad96a7/gmpy2-2.3.0.tar.gz"
    sha256 "2d943cc9051fcd6b15b2a09369e2f7e18c526bc04c210782e4da61b62495eb4a"
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

    output = shell_output("#{bin}/badkeys #{testpath}/rsa-debianweak.key", 4)
    assert_match "blocklist/debianssl vulnerability, rsa[2048], #{testpath}/rsa-debianweak.key", output
  end
end
