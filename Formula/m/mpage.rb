class Mpage < Formula
  desc "Many to one page printing utility"
  homepage "https://mesa.nl/pub/mpage/README"
  url "https://mesa.nl/pub/mpage/mpage-2.5.8.tgz"
  sha256 "2351e91d25794b358df6618f17a7013a28d350ec20408fe06f8123dc4673fe93"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mesa.nl/pub/mpage/"
    regex(/href=.*?mpage[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "860aacd1390ce895e9dd5099c4811c708d2b3990e0fe41928cf56d5ac7af89c8"
    sha256 arm64_sequoia:  "a596325fba30e7574a19d7fcf3b338f02fa91e9074a13609c7d356b9bba67b29"
    sha256 arm64_sonoma:   "c94c08b44f7dc6719d73f7eb8e103622190b9f189f3352dc8d4360c882280c24"
    sha256 arm64_ventura:  "73e7baeaab7049ad6283a84d4ded710eee5597bf08afaf91fe9d3e63fa254b28"
    sha256 arm64_monterey: "0a67c5c240e36df17b8133621bc3a620a8bbd211a44f3971edff3d81a363d652"
    sha256 arm64_big_sur:  "ab9465239a6f52df582be02ff654c4d5f64cf84b0674bb8326e104119dbc185a"
    sha256 sonoma:         "6ac0089f8a3aeb93e7670556f6a9191272c5c715cc53c3dedde1559a1f7533d8"
    sha256 ventura:        "fe00986658cf5c208b1335724d6856090f9b957c1bc937c016270cbc132d506a"
    sha256 monterey:       "a030ebbb33d31ab4620835a6d6fbdd335f5d9570198ed652c8cab55831a5b29b"
    sha256 big_sur:        "77f4a54443d7d8f6ee681d061c1e30aabc9021ceb6a5ff6a26bc85d992824f11"
    sha256 arm64_linux:    "066fff24a4048340ee0cc2028a3bfb93432af6fd546aecf61106c7f33a70032e"
    sha256 x86_64_linux:   "6a4e4a8c70d9b83690c2e0c3bd94574f8e3e6a0cadcf12cc80ba197d79186c56"
  end

  def install
    args = %W[
      MANDIR=#{man1}
      PREFIX=#{prefix}
    ]
    system "make", *args
    system "make", "install", *args
  end

  test do
    (testpath/"input.txt").write("Input text")
    system bin/"mpage", "input.txt"
  end
end
