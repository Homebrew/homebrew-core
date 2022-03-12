class Packetq < Formula
  desc "SQL-like frontend to PCAP files"
  homepage "https://www.dns-oarc.net/tools/packetq"
  url "https://www.dns-oarc.net/files/packetq/packetq-1.6.0.tar.gz"
  sha256 "2319efae884c8007df0e4e00435555a3e93a1f643f4a02dcb8d519203e443e4d"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?packetq[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd3f007444afb15a38d405e565cc6933820b5bec4b197947c98099209d860280"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "120a699588a29e106ad905ab89ecf695ddf14309b294226367afdfe7f002cde8"
    sha256 cellar: :any_skip_relocation, monterey:       "ef968250dd6953a82f237a6b31503860ad0c05edf21d65cf8d62a75599e47cca"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9a4c460d66722daf353e875130983c276a46349ce12ccc34d192f897d015838"
    sha256 cellar: :any_skip_relocation, catalina:       "a568edf7e7c8ddbdc15ad4fccc1566a33fbf5998a10193c193733377891c9ce6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a86c2ae28e6cf69592d6117143ab7b2776bdaa367bbdb588516876e89e229314"
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
