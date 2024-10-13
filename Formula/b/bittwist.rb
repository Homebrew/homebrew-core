class Bittwist < Formula
  desc "Libcap-based Ethernet packet generator"
  homepage "https://bittwist.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bittwist/macOS/Bit-Twist%204.1/bittwist-macos-4.1.tar.gz"
  sha256 "834854b003eb12e7db67c66ec14f897991bbc5c5d3f8432987acedfb709e79a3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e91ed44e0a346ad953441a88d6f532e2d947391b2fa4da2dcbe878025be1850"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4305454b62f5e0cb9e73c30343fabd7258546574ba05f1d7d7db9f2479a6c47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ca035c609c0c94c639404d1bb63470686fea04874057f72d852e46cc4f07374"
    sha256 cellar: :any_skip_relocation, sonoma:        "91c123e37af504975aad59f7c47debfcfe226d590440a679bb947ec549bb79f4"
    sha256 cellar: :any_skip_relocation, ventura:       "f99ce4712f984c50541d3a08fc2d65fc2823df205c5e9a1c7646a363dc37a96e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65af4e1f81a00b608e07e4ab4a3d7f81279e7f55ff77eabe90c136cc9e673f3b"
  end

  uses_from_macos "libpcap"

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system bin/"bittwist", "-help"
    system bin/"bittwiste", "-help"
  end
end
