class Cocot < Formula
  desc "Code converter on tty"
  homepage "https://vmi.jp/software/cygwin/cocot.html"
  url "https://github.com/vmi/cocot/archive/cocot-1.2-20171118.tar.gz"
  sha256 "b718630ce3ddf79624d7dcb625fc5a17944cbff0b76574d321fb80c61bb91e4c"
  license "BSD-3-Clause"
  head "https://github.com/vmi/cocot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efe840ebc69a0212b0563b64b05e44426624ee8ed3c0aa6ef8f8101d1ca7ea0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f91587cce3e6d8aee833b0eefcbc49b50d8851455e523390f9a8899f39cd50d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "835a54f7142add9b9a3ab35097a6821fc9c100568b54c2d7fa52c283fd5ca6af"
    sha256 cellar: :any_skip_relocation, ventura:        "8c309ff7d2661f534506c63909107b699d469d782d659e86f765b9e2a28bd319"
    sha256 cellar: :any_skip_relocation, monterey:       "d01d5f49b3bc174be130e15d2fbe1a2515064c5eef1a6e402ab9d2957c181874"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b1f6c60de8b11f5c3a3c454f30f551d2faf251185cfefacba11adbf61c12aaa"
    sha256 cellar: :any_skip_relocation, catalina:       "c56c078fce103138a45bd1c715dc3854b9eddf207575fada0e736b866d4f46bb"
    sha256 cellar: :any_skip_relocation, mojave:         "c5b0aa39597693d037438bd0f411965754539aaf50fbb2cb3b2a61082b6f4178"
    sha256 cellar: :any_skip_relocation, high_sierra:    "0070eb38e06043e3c1a4ad1b77205a6ed978ed300e8d0bb407391fecb191b050"
    sha256 cellar: :any_skip_relocation, sierra:         "a91ba93032e33b6a062b82f2df0b9170d5269cf0312d75eb6f16341fca54f9bd"
    sha256 cellar: :any_skip_relocation, el_capitan:     "60cbdadb074b019535319e5089d5c55c43b68e0b52a73b01cec3a9a8311e51a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2cd1dd3dbbe2f6474e43965f09859c3d9921a6b7e21507c2a2c70fe69335c01"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
