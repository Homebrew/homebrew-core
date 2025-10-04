class Packetq < Formula
  desc "SQL-like frontend to PCAP files"
  homepage "https://www.dns-oarc.net/tools/packetq"
  url "https://www.dns-oarc.net/files/packetq/packetq-1.7.3.tar.gz"
  sha256 "faa9a3700bf6010347fbfa595b7777d32059a77abbb027f6e070b419369d7718"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?packetq[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "112e72c771291bec60d3d430e7172edaa92e1288468005e614391280823d9822"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "30d4e340a8cb4181ac18e1a0861114366072fd9e7285403dede913b6d43c46d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c417535f739789d04d7738608d54fe38b4ef64031c4ff594f5e0405782ef7ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55fcb7a4a4cea35b2508da5a7431dd3f62724a2e74d0e7f5e9fbbdf07d9266f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "242b9c3cb3def53cf305ace64795c75dc548fb094b5820a53885db9343fba998"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba48fbdbb805d7cd4d98a01729cf039c0d712055119a67f2b9718f01bab6c24d"
    sha256 cellar: :any_skip_relocation, ventura:        "38abae3b37b0e57c4f6cadc99d35d21d1e5ea1dc1712420812a65391bf943ab9"
    sha256 cellar: :any_skip_relocation, monterey:       "379eeee8cd1a9b095adc60ff2147aa950cf81c98afeaffcb860e200a4500113b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6b6008c10a371a2a456ad6a8430b911941e6e385ecf6c5c3ebdeaecfe490fca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95b224f56ea3ceec3c1e6a13030405cb285de6861cee6987bfb0c472c68f7b5d"
  end

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/packetq --csv -s 'select id from dns' -")
    assert_equal '"id"', output.chomp
  end
end
