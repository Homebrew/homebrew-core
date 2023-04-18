class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2023.03.24.zip"
  sha256 "4bdfdd0655d1cbceae60fa48e495592a7aed775dfaa0ed2557f5416409ae2bed"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad7b3db634a68eb58a1cbce94f20980349537dcb11cde0aad1e4907b7d8583b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33cc38354166df25f69767c0819be491f7144d264b96070c1d8afca5fd461db2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebc11b0246a28b753b91f9b9d09a8298cc6211f6c183e83b25d6ddb676f8cc52"
    sha256 cellar: :any_skip_relocation, ventura:        "0c80af006bc4baccac153195eb2139312bfb7dc673ce0fcbae152acbeb7e1b5f"
    sha256 cellar: :any_skip_relocation, monterey:       "7201dfb7af69dded051ecc986a7316e225abe331d0a0b1d90c1659d48ab7843a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5af05722a34db737ec4f8d99b6002f65af7f7b1326f05922c5648f49a5417cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef59500f8c5378bb15832146562d13ea5f476b00748131f563108d60db544073"
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
