class Abnfgen < Formula
  desc "Quickly generate random documents that match an ABFN grammar"
  homepage "https://www.quut.com/abnfgen/"
  url "https://www.quut.com/abnfgen/abnfgen-0.21.tar.gz"
  sha256 "5bf784e6010b4b67e38fa18632b7e2b221c1a7a43a0907be0379a4909f5e536e"
  license :cannot_represent

  livecheck do
    url :homepage
    regex(%r{href=.*?/abnfgen[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "eab87d7376a80c7f80ea531c0d416ffd17c8382339891c38158763e67cab67e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e2396295b6a6b0952355321d37830f2a2f42b2b2deda9a7ec9162d7f224f0c98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ebbd726f391652bf3bd3c84107de75d1302ec42551c7355f9760c416915e2291"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77649fae7599272e9602a0b31d1c821f4f09b364d9e782a146a27bc961066194"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbb853413b291a12a931c32fe4698d1e97f263c70ea9635875afcdf2bf3a63d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "907493c609cdd60994448826e9adf685fd8048bb24e3dbea2db7440871d3dd2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "cdae00cf074d6a865aa7ec7854d6e3fde32756f8398aff1312b3bdc176cc6393"
    sha256 cellar: :any_skip_relocation, ventura:        "575c3555e7ba9555741886bd51dec912ba229d99f00461f0fa8e5bfcb1953e62"
    sha256 cellar: :any_skip_relocation, monterey:       "aabd22f0c8be1bfdb787b8ca17c303350ac9d726df2cb6ee2b760972c8fa6b1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d26f4e4456ba543aa9b54b8950d26cdd91b7f64e1f40e5b67d4266463f3f9aeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3d3524e2008a5cb3a6c5248cdddc948d023a0e1781246862c0035d7a3cbf6bbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76f35d17e3a1bad80de9ef0c2fb654882619b43a70f00cc23293b7d63c3fc513"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"grammar").write 'ring = 1*12("ding" SP) "dong" CRLF'
    system bin/"abnfgen", (testpath/"grammar")
  end
end
