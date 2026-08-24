class Badkeys < Formula
  include Language::Python::Virtualenv

  desc "Tool to find common vulnerabilities in cryptographic public keys"
  homepage "https://badkeys.info"
  url "https://files.pythonhosted.org/packages/43/71/e2a8f3e504f3cdaeded9c4726dff0929d38ec4ab447560019c690a4777a3/badkeys-0.0.20.tar.gz"
  sha256 "b1cbf5722dd3daf34d7dd205b33d0a57650608ce7a3ce6d6be595c6cfa5d27f2"
  license "MIT"
  head "https://github.com/badkeys/badkeys.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "782ce0a0ddb91780b60e5de6b43af415f82705228d07c51a407d7cdbf6fb58b3"
    sha256 cellar: :any, arm64_sequoia: "17ab5252ef5caf13185ec3f17c681415fe1aba25ebadd1c485d099bd3d435a4d"
    sha256 cellar: :any, arm64_sonoma:  "bcd881be16bda24b4b8846605ab14191525a702a5d3d23da075b7548f73451f9"
    sha256 cellar: :any, sonoma:        "10d63e76b950fa2afa98b55c559b170abab0ab2280abc35ab141542c98b6f0d0"
    sha256 cellar: :any, arm64_linux:   "39440953d69aec9be44039a73443708372aa9d5ed89aac4e4a4f72996ead5c1f"
    sha256 cellar: :any, x86_64_linux:  "28e1a8d73bb7867d4fe2ed590364a9a39c8d00e855326d3dadf06f9acc8527d1"
  end

  depends_on "cryptography" => :no_linkage
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "cryptography"

  resource "gmpy2" do
    url "https://files.pythonhosted.org/packages/03/47/5c59682cd4d94291382f447dbe1f6229c8b8a144aa85d32d38ecaf8cfb73/gmpy2-2.3.1.tar.gz"
    sha256 "313f35e9fe6b9ddf72759b14dac25166fe5757c970403e4bbf87a70ab2be07df"
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
