class Badkeys < Formula
  include Language::Python::Virtualenv

  desc "Tool to find common vulnerabilities in cryptographic public keys"
  homepage "https://badkeys.info"
  url "https://files.pythonhosted.org/packages/bd/a7/b222a5f0db2bc9e765252a109da1ab1baeed0da6e0b050e2baa3208650c4/badkeys-0.0.19.tar.gz"
  sha256 "dc3c3431b79c11dbe54bcfbbdc1e263098136585a4f6f497d81636e55a5b7b5e"
  license "MIT"
  head "https://github.com/badkeys/badkeys.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8e6d799c2deb61c1100c0680b025fa512160d444a038a487386959f807292f0f"
    sha256 cellar: :any, arm64_sequoia: "ff8d118bed85799682f42a5b0fb7f8cd85d720c6fb757ffd2f2287c8e1528d30"
    sha256 cellar: :any, arm64_sonoma:  "cdccb77c8d6f9635065689d456238497a721942aa5277555bdd325f378993a7e"
    sha256 cellar: :any, sonoma:        "6aa397ecb8a0ff1c7ce69388567a23f02c209a194d25c9ebc6a8b7c2211e4d37"
    sha256 cellar: :any, arm64_linux:   "26435059f9d064ce89dcc7eb89e711813d63ef05d83d4a2bfb0749c635ab6d06"
    sha256 cellar: :any, x86_64_linux:  "9666be3c4976a406928617d3458763c6a28fde11c88d1f0a50886e50fc096b0e"
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
