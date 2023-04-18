class Nmrpflash < Formula
  desc "Netgear Unbrick Utility"
  homepage "https://github.com/jclehner/nmrpflash"
  url "https://github.com/jclehner/nmrpflash/archive/refs/tags/v0.9.19.tar.gz"
  sha256 "cb0757d4d38b5061d8a71ccb853f117675d3de3ec4aaa4e9179f614bbbfac31d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a23b76f90200b17b64d24159e52d68a380675c7c5309fdd14f1120fd7cb52c04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f775d066942ae6c498ecce6c71c6a476ee08f525a7b5ab021270bd25bd6c638"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdbcc636162e6b8a640b2da8afae4bcfde323279936540db098e901d6329b068"
    sha256 cellar: :any_skip_relocation, ventura:        "9ffa51384a566799e5ef18161d1eb2e911421c3b7c14956484e7da1d68602386"
    sha256 cellar: :any_skip_relocation, monterey:       "fc95dddef5ddc1984f0489dc35d917fe2dfc1a94ba3a7bac7b93ed377021a07d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d855e61eb821b6a83b02845079a29cc5365cf4a47bd4e89f767f257a10bc725"
    sha256 cellar: :any_skip_relocation, catalina:       "f87bdfe3c420e7b52a71f0b5f46971c0938e98f1bb4a74eb6c7bbaf751ca995c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "586c5e60b02c0ccf7915bc820e7ae1649f4b8044c51af26642949f6812c13cc3"
  end

  uses_from_macos "libpcap"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libnl"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "VERSION=#{version}"
  end

  test do
    system bin/"nmrpflash", "-L"
  end
end
