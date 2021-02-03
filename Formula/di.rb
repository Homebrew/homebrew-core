class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://gentoo.com/di/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-4.48.0.1.tar.gz"
  sha256 "60508544319eab687f5172a67bf3679c2b8576dc365629ba63749bcad688b467"
  license "Zlib"

  livecheck do
    url :stable
    regex(%r{url=.*?/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f73ef475c2e9c76a19cb31c8554d5bcfa2f3160e5d16b90c05c7623263c490d2"
    sha256 cellar: :any_skip_relocation, big_sur:       "e3be4bfb7fcbde3a31b282323e46ad7c7fedb057dd0bc60504c60863dc9f14f8"
    sha256 cellar: :any_skip_relocation, catalina:      "3fec602b01937a696deb147c5a0a22f9ea2bfc535980a9f10b5ec89d230d9999"
    sha256 cellar: :any_skip_relocation, mojave:        "6e8b6d40cf8cdbc8b73524d01c87dcf1adf4039155d5370436aac3923aad402e"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/di"
  end
end
