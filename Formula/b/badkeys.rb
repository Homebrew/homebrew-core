class Badkeys < Formula
  include Language::Python::Virtualenv

  desc "Tool to find common vulnerabilities in cryptographic public keys"
  homepage "https://badkeys.info"
  url "https://files.pythonhosted.org/packages/f2/29/3e87b8c7fc9779bf216349ffcaed9a748928a015b77d71ab2e0dd1b4e073/badkeys-0.0.6.tar.gz"
  sha256 "ead74de1a60844bbd8019710aa8314ecde82ac077eee72d68a6f185e7ab5ee48"
  license "MIT"
  head "https://github.com/badkeys/badkeys.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a4650c9a7766c7bb41ddcc1dff83ee46f3c61dbcc59372c81dee306038e1de21"
    sha256 cellar: :any,                 arm64_ventura:  "48c1bfa3d51f2a137d406c0d37e1d669b482dbcc72e881b7d44fb3c9a466f698"
    sha256 cellar: :any,                 arm64_monterey: "7f98a06d22880f47f54f33f11ce7711b5319315b57dfdcadc066c4459b9b4fa8"
    sha256 cellar: :any,                 sonoma:         "eebacd8833af7dec4587017bad38f53e1a400931a66cd88148146624607a7339"
    sha256 cellar: :any,                 ventura:        "5466bbcd795e901352daa14964d8d80fbf0f08e129516be98c23eca170337599"
    sha256 cellar: :any,                 monterey:       "1da07989afba7bf157f145d4d9b11d49f8e5ad24fcdca817dcb9666b81ef25b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53fa9501f5bc882d53d5d0b205371046d4a9051fc634c6bcb53c89bd06c1d45c"
  end

  depends_on "cffi"
  depends_on "cryptography"
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "pycparser"
  depends_on "python@3.12"

  resource "gmpy2" do
    url "https://files.pythonhosted.org/packages/a7/d1/249a57c014c3a73ffc842d5a33a1ce3d4198f3e6ea0ee84c237d24b5a556/gmpy2-2.2.0a1.tar.gz"
    sha256 "3b8acc939a40411a8ad5541ed178ff866dd1759e667ee26fe34c9291b6b350c3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/badkeys --update-bl")
    assert_match "Writing new badkeysdata.json...", output

    (testpath/"rsa-nprime.key").write <<~EOS
      Invalid RSA key with prime N.

      -----BEGIN RSA PUBLIC KEY-----
      MIIBCgKCAQEAqQSg27883tGr5jtyOaZkEn597cuw1Wz4wWuFp1quvHOyiMId7L7m
      KHh2G+WQaEEBKl2A/M/tXgdfbrY0NnW3SMIZ9PMTWJNjtAqjBKVBDXDJbJhOpvya
      gL4HBKR6cnB0TE+3m0co6o98xRT7eFBP4V9WyZYIG15XDruFvGkgeqmXefqf5BB5
      Erquu6RePYNt25I3SFM12kZTW+HcrDyj34CO4Jxkw5JI5bUtP9wV5ocr/Z5FmvmI
      Di3eNbHBVteLN3BIuFax8JQvpcdwEjy7Qdro5Ad3a3Ld4//2Vn/mAkGPop/HmJme
      wI1poiKh+VgF87bloijO+izBYk/eo9ZWWQIDAQAB
      -----END RSA PUBLIC KEY-----
    EOS

    output = shell_output("#{bin}/badkeys #{testpath}/rsa-nprime.key")
    assert_match "rsainvalid/prime_n vulnerability, rsa[2048], #{testpath}/rsa-nprime.key", output
  end
end
