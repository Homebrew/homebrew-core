class Badkeys < Formula
  include Language::Python::Virtualenv

  desc "Tool to find common vulnerabilities in cryptographic public keys"
  homepage "https://badkeys.info"
  url "https://files.pythonhosted.org/packages/57/7d/f74cca4803f32e3088ae24e5186693facff1fb9c9e3f81497c4fbde63591/badkeys-0.0.16.tar.gz"
  sha256 "c9d292ea1c78f6076662b923d854620f08dce46df1d4c162185625c7bfe58030"
  license "MIT"
  head "https://github.com/badkeys/badkeys.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d2c34e7ce3a7ad3b79e579fffa5d268e4666fff4ceecbf891751ec6756fd3829"
    sha256 cellar: :any,                 arm64_sequoia: "21db3db1703244ecabc2c1e5b6930b06b795d19a4fe251bb0d65671efcbb74a5"
    sha256 cellar: :any,                 arm64_sonoma:  "a110ae31d0a3982fbe4491469ed5355c255b78f415a11d87192965a76c555c62"
    sha256 cellar: :any,                 sonoma:        "00f8b99d969e15b2c595d61da82a8032239753c981108930063a95be5ae4f98d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c6f55b83a73a639171aec0c6903c45113bcb6410af62aabb7f5ee14f612d88f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d9085c2391bf77d4762907efdeea82d5a03d647f496af0cdef479e415743b35"
  end

  depends_on "cryptography" => :no_linkage
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "cryptography"

  resource "gmpy2" do
    url "https://files.pythonhosted.org/packages/fa/58/aff69026cd43a284b979d6be8104a82bd2378ca8f1aaa036508dbee7f1d9/gmpy2-2.2.2.tar.gz"
    sha256 "d9b8c81e0f5e1a3cabf1ea8d154b29b5ef6e33b8f4e4c37b3da957b2dd6a3fa8"
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
