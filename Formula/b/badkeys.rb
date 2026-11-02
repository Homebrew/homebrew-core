class Badkeys < Formula
  include Language::Python::Virtualenv

  desc "Tool to find common vulnerabilities in cryptographic public keys"
  homepage "https://badkeys.info"
  url "https://files.pythonhosted.org/packages/7e/b7/b27f5d7e2c70301ed8f6bd743a5d830195aa1dd49b708d786261873e9b8f/badkeys-0.0.22.tar.gz"
  sha256 "abf12aa9ecd253f7556959a966a4a39b35bd2d452c1a5b12e220b182fb0fb172"
  license "MIT"
  head "https://github.com/badkeys/badkeys.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "57222ae23f419feb7615f04ebccb0d0d3366cab46e1064746a901ca098065b95"
    sha256 cellar: :any, arm64_tahoe:       "d1fab523955b353013e746a207924c01bfd07fccd806589275d59dcee2b376ea"
    sha256 cellar: :any, arm64_sequoia:     "d45ca9eca953a54e91c64a99f13ec3eaa308b0b8974fa294ba85e7fb01169cae"
    sha256 cellar: :any, arm64_linux:       "13117f68cb655993392c453416f1368769a96822b92652d5c2079f2587ff2455"
    sha256 cellar: :any, x86_64_linux:      "8933edca489a921c6991f2e0b0d601518b0c6750ac1aa6134d6e702a30840d28"
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
