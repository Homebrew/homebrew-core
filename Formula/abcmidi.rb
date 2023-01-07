class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2023.01.06.zip"
  sha256 "5a68be4051ca788a5aae955802ac713f13f5906952c551b3ff2c8abdce7c9312"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "431bbc678608a6113f87b2d994554ad2ea7ce932b47abb226cb076f45774bb27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad3d68e9749e516a467892497111bb777c91af2da22d800971afd09980938a2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "800e7933e79a10c50b06117b0111b748e3a47d6386257ff3852f0bf3b043693b"
    sha256 cellar: :any_skip_relocation, ventura:        "52a0bc18b5fadcbac9ea75ab745c9f284ad976d2b4e935d711169a0a32b80ed9"
    sha256 cellar: :any_skip_relocation, monterey:       "50ed9d19be51b60c406c5855aae0d106598dec94dd4e0ec5793bf505fc0555d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b869b33fd208b1863d91343d0dad8ebbd5d4118bbffea0b2774573d40c1f152"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c318088b5eed76a66ba1d2fb879458f3ada7adf4c9f53d095eaefa67ecb5664f"
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
