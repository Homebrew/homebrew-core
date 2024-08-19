class Badkeys < Formula
  include Language::Python::Virtualenv

  desc "Tool to find common vulnerabilities in cryptographic public keys"
  homepage "https://badkeys.info"
  url "https://files.pythonhosted.org/packages/88/fd/0b40be2d9d46befa087cc5ca494ebadf5777cb05a5ef6ee27577e82ae409/badkeys-0.0.11.tar.gz"
  sha256 "0bc38ac6e683d5c85f7abb15de5ea14e1bf428267e60a9240b1faa34bd91f018"
  license "MIT"
  head "https://github.com/badkeys/badkeys.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b3c315bd10c223cf517cd24a75621bc696d9cbc9f52f45c08969394dea6c1ce8"
    sha256 cellar: :any,                 arm64_ventura:  "e3604277f5e04f67c1d57bdf70780be4ce9b19efc1d540c860afeafc00a4e728"
    sha256 cellar: :any,                 arm64_monterey: "ef288acf3f669b31d26ef1660eb0bd0f9546062b10791c95655e26700227b121"
    sha256 cellar: :any,                 sonoma:         "31738d1558520580fdc4aab73b26b6073a17327a7c76d1e409380556694b7014"
    sha256 cellar: :any,                 ventura:        "fd6ae5b2442c5112663f2dfa802bfdc6a029c13878987573b9a5a6902232618f"
    sha256 cellar: :any,                 monterey:       "c6ff01c024408b8eca55649784aa2716aec253426b4d6d46e9708bf356fdf8be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4138c4ef015837d568b4155ab34d44ecd16719f39f5ed3ae5e881da2cd1ee69"
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
