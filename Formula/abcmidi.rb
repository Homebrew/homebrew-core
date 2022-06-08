class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2022.06.07.zip"
  sha256 "2e42c21452532d1a0cdbe5f53caad2ae4ca6bcb324aeec106f69c58f8fb2d60d"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6860b3ad07b10c420c64b04bda5167d70ef76103e1013338cf3a2d4994d7daf6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d84f8bb8e4a94e9e4d43c369821df2e9ff610c932136889d7af590037f832ad"
    sha256 cellar: :any_skip_relocation, monterey:       "504833f721e31a9c22e9fe6a6cdd31b2900a4c0be6de1c13629df3279cfac061"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb80f94f18c3e6a575898b1e3926b5cbf678a68a7338b36b4c969a70a214c9b6"
    sha256 cellar: :any_skip_relocation, catalina:       "0ecbc790c29705112f8525c5067b30e98e6f2bec00e095c956edc1a40d255937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d20cab7e6de038c919e8c2145409cec984c6fe433b596433ecb45eeda1a0acdb"
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"balk.abc").write <<~EOS
      X: 1
      T: Abdala
      F: https://www.youtube.com/watch?v=YMf8yXaQDiQ
      L: 1/8
      M: 2/4
      K:Cm
      Q:1/4=180
      %%MIDI bassprog 32 % 32 Acoustic Bass
      %%MIDI program 23 % 23 Tango Accordian
      %%MIDI bassvol 69
      %%MIDI gchord fzfz
      |:"G"FDEC|D2C=B,|C2=B,2 |C2D2   |\
        FDEC   |D2C=B,|C2=B,2 |A,2G,2 :|
      |:=B,CDE |D2C=B,|C2=B,2 |C2D2   |\
        =B,CDE |D2C=B,|C2=B,2 |A,2G,2 :|
      |:C2=B,2 |A,2G,2| C2=B,2|A,2G,2 :|
    EOS

    system "#{bin}/abc2midi", (testpath/"balk.abc")
  end
end
