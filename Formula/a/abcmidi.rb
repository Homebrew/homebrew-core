class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2024.03.13.zip"
  sha256 "939a578551a53147b761e3199a786219153507117be4bb1296cde210b4e25e96"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e4651ca53ef45d28718943245ae947d25a9bccf03fd70f7e5538cb56898e355"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4dbf47a4e255a40decd1b6a756e888442144a2dabc3d25443cbc2c0b80ea4cb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a68b22d67a37e9cd8e97ecd118f6a03b48664b503a7f002a512ea737282762a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae8b3f994a280baeb509a5dbb8b76cdc88caed2e901a6f8f6791a09b11544984"
    sha256 cellar: :any_skip_relocation, ventura:        "a21196587ccff2d19d75c8d3457eae65bfc5eadffec47b968b842a1836185920"
    sha256 cellar: :any_skip_relocation, monterey:       "561c26ee1708cce98b2a83ff589a5a242129de3159de37e4690d0582b07b105f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54f6369cf823b6fc63b420cf9eea37ce7904adef676b72e679f68e37aeac2485"
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
      %%MIDI program 23 % 23 Tango Accordion
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
