class Badkeys < Formula
  include Language::Python::Virtualenv

  desc "Tool to find common vulnerabilities in cryptographic public keys"
  homepage "https://badkeys.info"
  url "https://files.pythonhosted.org/packages/8b/fe/01e4617b44bbb352023bc1ee7e2eef4358d59d0bab9677f52698dbff44b1/badkeys-0.0.13.tar.gz"
  sha256 "6013a2496221993d726ab624170108b82ed188bf2b03eb032cfaaee17354530e"
  license "MIT"
  head "https://github.com/badkeys/badkeys.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "091903ae93eaf73bcd25d6af039458e5df16e2802638fdf8d40179f0b993a4ff"
    sha256 cellar: :any,                 arm64_sonoma:  "f4d06958f60fdf734839d289015e378324dd38668446312437244db26db0e570"
    sha256 cellar: :any,                 arm64_ventura: "b3e77db1e77edb273e6022bea8440e651fa300263c47b2f8d4045114ad658bfd"
    sha256 cellar: :any,                 sonoma:        "4b23d32e958d853a341359f6c2627387e1628cbf72abf3f8edfe749976db58e8"
    sha256 cellar: :any,                 ventura:       "71564d54d9739f33b60db86b68761a7f0414a2837df84f2ec8b62f1258701cf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bc3a6bf8c1a8cedf53f5725d98e84de9987494b1503f69f2fe18174458b2a1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "336a1ff4d2f198153a7c2ebaea51bc0dc33cb651fff3cf60a36b235477990645"
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
