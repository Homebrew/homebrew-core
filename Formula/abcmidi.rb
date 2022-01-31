class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2022.01.28.zip"
  sha256 "4e8b532d3bc7af8752b0f48c810247eb18cd3e1e5b814c14a89d4e2a3bc44310"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49870b6a8f7f04980d6e6bcf2cde8449b698d41c1f9a0803e0943feabbaa53ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c5029c46e27a083b380f7e19ab78a6af01df50c2a57fb47b1ba62ac36943d70"
    sha256 cellar: :any_skip_relocation, monterey:       "cc0710bf6df23a347347ca56a8531ab66eab5ccbf1064742c2f0cda66d50a85a"
    sha256 cellar: :any_skip_relocation, big_sur:        "35d5a1f09f59d90c54a8b201e9098bbf8cb99f6819fa764bc4c0bee057676a1a"
    sha256 cellar: :any_skip_relocation, catalina:       "6db934a3e630c81fe5a547b5c74b779674129d6595aaab448594d13880e919ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c47aa563f8919700becee4057b90c87dbd4d4c0c41475776861bdfdaf509622"
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
