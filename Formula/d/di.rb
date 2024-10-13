class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://gentoo.com/di/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-4.54.tar.gz"
  sha256 "f500fc1fe27586738e12d773dabc9af108fe4690d6bbc8220a9c3c3f774f8748"
  license "Zlib"

  livecheck do
    url :stable
    regex(%r{url=.*?/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1bb3fbab43a1f2fd062c5154e3582d7224f053b0364d30d11e1f4e88224dd43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec2296ef6088bf0e843da5d0b755bb9f3c3f71d747d382f0513829914596564b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dfc6a06a336e552d565124e549b911a31f921c87fc5f375867de06231384f921"
    sha256 cellar: :any_skip_relocation, sonoma:        "d48fa4ce660887d5f3199aa6f86beefbe4383d265ad7bd258891af7c48919a51"
    sha256 cellar: :any_skip_relocation, ventura:       "3ac6549470a2ea28db9efdfa4833012b3bfef9491928ea2e559e778d4d317c6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35fec06e1b5e044e46eff031a94499002641bb57f11ed93274dddb13f3040723"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/di --version")
    system bin/"di"
  end
end
