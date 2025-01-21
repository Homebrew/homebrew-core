class Badkeys < Formula
  include Language::Python::Virtualenv

  desc "Tool to find common vulnerabilities in cryptographic public keys"
  homepage "https://badkeys.info"
  url "https://files.pythonhosted.org/packages/3f/51/e1acca1ebddf0dc44937e340690364051e2e79e6d4bd628aba9f30f56115/badkeys-0.0.12.tar.gz"
  sha256 "2c80bbb84a39d0428082ee8f2990a91a6f30f6df85e9a75091c4a862c08611e1"
  license "MIT"
  head "https://github.com/badkeys/badkeys.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "db0035f6d4086c363a198993d665cdbf62e6bdaa582feef7a53e42a75c78baa7"
    sha256 cellar: :any,                 arm64_sonoma:  "a07c510effd9558e8702ec1dcbbd88011d0146ece0d30b9cefae5f952eeef64a"
    sha256 cellar: :any,                 arm64_ventura: "3f63a5459c881ca65de269d7571320fa8dd8411bcca7e879406ca2d06097ebf7"
    sha256 cellar: :any,                 sonoma:        "5add8b492ee854ae1b95edd548fd8d5befbf5b771ebd471ea9acde72afeba8db"
    sha256 cellar: :any,                 ventura:       "91ccb32758b85cce386d29a2ac9f0b73555c5083323dd937c29db85887d1d3a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da77957bdd0858d8eb36a5ae4dc76bbc4cdde70f68b5a88347601db11fb046d4"
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
