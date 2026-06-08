class Badkeys < Formula
  include Language::Python::Virtualenv

  desc "Tool to find common vulnerabilities in cryptographic public keys"
  homepage "https://badkeys.info"
  url "https://files.pythonhosted.org/packages/15/85/39d573936d3f6a208c795f17f9fdc3ebd8cd4edd46d17f9852a5f2f56cad/badkeys-0.0.18.tar.gz"
  sha256 "273403cd277f79d6e5b9c262611bdb763a0be8703b82f9818a5d121ce39669de"
  license "MIT"
  head "https://github.com/badkeys/badkeys.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "939345102044d4cb5b91f19ce47af8dabd04a966ffb986dffa8d03bae09b38ee"
    sha256 cellar: :any,                 arm64_sequoia: "e047092e5a4a6fe5c1a415c2a00cb8c7f848caef707cd9e7749a9b067e6b49f9"
    sha256 cellar: :any,                 arm64_sonoma:  "7a4bef0f516a7358a1e96335a6492f98aa8e88fdd82e1fd6609afc005e297942"
    sha256 cellar: :any,                 sonoma:        "e7e16b9c22829fbc43f911fba0b21f66dd9936d06376377cf72b354dffca95ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a803a4856fa1cb43932359e8b248ec6d7c5539f8151cd235794c3d3a071c182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "869b2ef1b634c2c9e8225bb461576ea781a827d05bc899edd85fb14d47a430af"
  end

  depends_on "cryptography" => :no_linkage
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "cryptography"

  resource "gmpy2" do
    url "https://files.pythonhosted.org/packages/57/57/86fd2ed7722cddfc7b1aa87cc768ef89944aa759b019595765aff5ad96a7/gmpy2-2.3.0.tar.gz"
    sha256 "2d943cc9051fcd6b15b2a09369e2f7e18c526bc04c210782e4da61b62495eb4a"
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
