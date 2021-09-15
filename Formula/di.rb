class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://gentoo.com/di/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-4.50.tar.gz"
  sha256 "82f08b6c2549fd6ab2e9cb596135a70883ffd4136d176466ae0ec9ba67a3492a"
  license "Zlib"

  livecheck do
    url :stable
    regex(%r{url=.*?/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d4135217bb9c6a8141be9af407c421299441c2bd4d0e3304c45b3a9203ba57dc"
    sha256 cellar: :any_skip_relocation, big_sur:       "2ea8c9f4d3cc6f05716b53fce8686536e9cbcb873e915227cba240e8e0ae81f6"
    sha256 cellar: :any_skip_relocation, catalina:      "250f47d6e8b6ffe545cc3bf5421bde97e342f901e66ac4deb4b59aeaf1c5c308"
    sha256 cellar: :any_skip_relocation, mojave:        "c0c124d45daab04a22e0d831b0288d39141ad7cd335fb60fea8662c6992f8b9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f606218c445edbf9da34b9b8cc0a72f892e6d8c4ebb173bbfd4e3540bc4a4edd"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/di"
  end
end
