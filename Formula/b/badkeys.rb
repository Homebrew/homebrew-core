class Badkeys < Formula
  include Language::Python::Virtualenv

  desc "Tool to find common vulnerabilities in cryptographic public keys"
  homepage "https://badkeys.info"
  url "https://files.pythonhosted.org/packages/88/1e/8f47852ae7030e034f5d2b1710e2e45c5fe1ae2233f2e2ae62acc93ffcc0/badkeys-0.0.9.tar.gz"
  sha256 "c1aead663d8cc8a715669750fb39b3d0d1e6254b35c49c3f577bc13c20196292"
  license "MIT"
  head "https://github.com/badkeys/badkeys.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "08567dd3770e8bea78ea608ff64b3431d22296695f6f6ceb36f3d657ce1e4440"
    sha256 cellar: :any,                 arm64_ventura:  "f01a3b1c481e70752e166995036176cd90431840e193d2e4c01ad46214c5e60e"
    sha256 cellar: :any,                 arm64_monterey: "58f633f7ebd1e807834444fa4e46968b7bfba890b8ff61df0459bdd0f79be4f3"
    sha256 cellar: :any,                 sonoma:         "4e124ac5bb15a53b2c4c9529d89ab7a6cd35bd1b7cc71624d74f9db5258d924d"
    sha256 cellar: :any,                 ventura:        "57401dcd3ba8b971565cc5db0ae1357902a5d24147585d7e8d2731931b51a06d"
    sha256 cellar: :any,                 monterey:       "199ac579e133313da8dfe60edfcf85ab0a64a6fb8257a0d6a3a807ddedd1283d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e98238bcd30fba9f6dc37f59601c2e5ac1c6f9ac534983b82192c8e1bbfb53b"
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
