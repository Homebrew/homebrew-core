class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2022.02.13.zip"
  sha256 "d84ba358717ed930b8ab5773eafab440463161d06060375c5710ec19bc77fbd1"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fadfd43f4ed7a96aa84cf8282e87893605c561dc1b367c64b9963fd9111cd15e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd57d6417dee9625d95a5c3a39104e19637731f2bfa8b1c2e9d592edaf56a4b8"
    sha256 cellar: :any_skip_relocation, monterey:       "92a21f5baeb007d7d5df0e2796adf367f10fa7a05199ed574da182bf4ecf6901"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f68cfb43c22a0f0f819d4202142ef850383bc56c7cddbc11c2117154811c8a3"
    sha256 cellar: :any_skip_relocation, catalina:       "9eb9b315c6e986a6be11e39003e7102a518d78b55399ec7e5d00483a9cffbd94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "037e2ed491efb76565cccee865401f85d4ff49ea365dd4f2bd92fe4b78729720"
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
