class Badkeys < Formula
  include Language::Python::Virtualenv

  desc "Tool to find common vulnerabilities in cryptographic public keys"
  homepage "https://badkeys.info"
  url "https://files.pythonhosted.org/packages/ef/be/ebdc7b274a4bacaab1d0f01da8237b5dac6e98f04063b7802a6cf88a75ea/badkeys-0.0.8.tar.gz"
  sha256 "158953a0f695e2d56bee7c41ec8bc0958a6465f7d555e5583deee62dbbed3902"
  license "MIT"
  head "https://github.com/badkeys/badkeys.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "40595744dd8f4688f61821a704c4dbdd0de5c91d8c587310d6c16be2bf831ebc"
    sha256 cellar: :any,                 arm64_ventura:  "9ce884dbabd2ad73147dd7a70b513b2aa858e5f2916c33b03b245df03c384798"
    sha256 cellar: :any,                 arm64_monterey: "8562fc9c4360acf579ebb96defe0ce7d6c51ce0bb8816ee023ed9146c61566fc"
    sha256 cellar: :any,                 sonoma:         "427b7c1f42f0514e5529d9c3af934304138a4123f01f2b37e39cd6086edb7395"
    sha256 cellar: :any,                 ventura:        "8bd57365869c7ebcab523491eef790d2ce2d62c9a7b98c689527a5e390fcbefd"
    sha256 cellar: :any,                 monterey:       "c28cd99688151c08bd462cb5f77192bd926ad23694a37392d35442a3827c33fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02895613efd4dd45eb8c298eef3db5f8d76fbc0e5a33fcfa8be3201d5569aea6"
  end

  depends_on "cryptography"
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "python@3.12"

  resource "gmpy2" do
    url "https://files.pythonhosted.org/packages/d9/2e/2848cb5ab5240cb34b967602990450d0fd715f013806929b2f82821cef7f/gmpy2-2.1.5.tar.gz"
    sha256 "bc297f1fd8c377ae67a4f493fc0f926e5d1b157e5c342e30a4d84dc7b9f95d96"

    # upstream bug report, https://github.com/aleaxit/gmpy/issues/446
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/d77631527c866bbd168f7add6814e3388033cf2f/badkeys/gmpy2-2.1.5-py3.12.patch"
      sha256 "6b0994285919e373d2e91b3e0662c7775f03a194a116b5170fdc41837dd3551e"
    end
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
