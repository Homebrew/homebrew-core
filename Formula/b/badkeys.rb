class Badkeys < Formula
  include Language::Python::Virtualenv

  desc "Tool to find common vulnerabilities in cryptographic public keys"
  homepage "https://badkeys.info"
  url "https://files.pythonhosted.org/packages/a1/05/6f1939e3fb4b7cdf7799d7a200c0151ca6a1662042a283b658fe98627f9b/badkeys-0.0.21.tar.gz"
  sha256 "a4323c2a3de67e81786e87271d8c1cb302eed89054b770f85dbf1f95ce4264ad"
  license "MIT"
  head "https://github.com/badkeys/badkeys.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "f7745b11a144fdaf59fbbde2ac8f09d0bd48d80de4ed7c5b846787ac2dbd954c"
    sha256 cellar: :any, arm64_tahoe:       "19684ee467e099008191b249bd50e48d1e372403592550cdb5d74c0ecccc7ba1"
    sha256 cellar: :any, arm64_sequoia:     "091e81418fcba127bb71caba86506de8d15cadf8f414978611b9a4cd58f2b2a3"
    sha256 cellar: :any, arm64_linux:       "76d09360da1ef272f4ea89d40d4c2ac8c7b158f3cac7f0bafcd9ef9ef01caceb"
    sha256 cellar: :any, x86_64_linux:      "47aa113209ead5eb41f85e9ef9d9e55b55a11adfbb3ca223c9a615d174ece102"
  end

  depends_on "cryptography" => :no_linkage
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "python@3.15"

  pypi_packages exclude_packages: "cryptography"

  resource "gmpy2" do
    url "https://files.pythonhosted.org/packages/0b/3d/1c648af871024438207d5a017fb3f0ebc6da6b59bb9ff6f5047464a3192d/gmpy2-2.3.2.tar.gz"
    sha256 "f20b7e2f8fd16f8d6846bb5b73359c3cc5aa41ec5cf266321d362f547c8fd097"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/3f/e8/7325d258199b159eb2c03fe32107533e2832e70e63f4fb88a6aa00023201/pyopenssl-26.4.0.tar.gz"
    sha256 "28dfcce0162b9211413e26dfbfdf1d24317fbeba18fc93c12400a1856b2a0bc7"
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
