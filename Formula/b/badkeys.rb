class Badkeys < Formula
  include Language::Python::Virtualenv

  desc "Tool to find common vulnerabilities in cryptographic public keys"
  homepage "https://badkeys.info"
  url "https://files.pythonhosted.org/packages/11/5b/2a1400df2f62c3f473d46dd8ef8f7591a9a052b7f73b364d71f88bc7ae95/badkeys-0.0.15.tar.gz"
  sha256 "620b07053f1bff5041201923187c839454332ee474dcd793b4ce6c90276ffd6b"
  license "MIT"
  head "https://github.com/badkeys/badkeys.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "005315fdbc9c5fc6b4b28c07199fc7285a434a1b441aa56c4da646c0290b2fe1"
    sha256 cellar: :any,                 arm64_sequoia: "da809e3b1d9357aee1f41777c5cb5e27cd119f9963eb6b0ccc95f082d68cf196"
    sha256 cellar: :any,                 arm64_sonoma:  "82800c5b15c870d1684e02a66a9562fce2cff2bd8fe051ac88b398f1386234fd"
    sha256 cellar: :any,                 sonoma:        "aa62342782ee8322039087072a430f2b492cdf9eb300b13385d87d5f5004a07f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ea712ef7a3c81a7e477b7ba28c1d19d9cc603f95f6e774cd9e9c2916200155b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b19433c10ecf99f90fb890a830e1a70a693bb9f1e2f4a471d79b3b19fcb78c5b"
  end

  depends_on "cryptography" => :no_linkage
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "cryptography"

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

    output = shell_output("#{bin}/badkeys #{testpath}/rsa-debianweak.key", 4)
    assert_match "blocklist/debianssl vulnerability, rsa[2048], #{testpath}/rsa-debianweak.key", output
  end
end
