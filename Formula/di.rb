class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://gentoo.com/di/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-4.51.tar.gz"
  sha256 "79b2129c4aff27428695441175940a1717fa0fe2ec2f46d1b886ebb4921461bb"
  license "Zlib"

  livecheck do
    url :stable
    regex(%r{url=.*?/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f0155678e6e44db1dbfbc24fff96aaee23c22a69d553457dd8ac1f9de13b527"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fc57febb3e9e00603674540b9c90fff49df3f9b376149fd3ed37ed72d3c29b8"
    sha256 cellar: :any_skip_relocation, monterey:       "0ec56fe7507f200c983d2bbc2ade6465b8bf26c7714bf2626513312afa2b6568"
    sha256 cellar: :any_skip_relocation, big_sur:        "388ffea5e8416c1703aa07e2594ace704424987b1d99ee31718ef3cf6e9819d8"
    sha256 cellar: :any_skip_relocation, catalina:       "73122a618e0a2f834311d93ba4f8d11be103ea2bd8e8616af8690c34607104e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58af16241c8439553918521e731d4164a6e570487179d65d50897f66ce932a61"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/di"
  end
end
