class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2024.06.09.zip"
  sha256 "9bfe1aa7fbdaddfd57e0f2106958fc3df70cd5d9b65b577e9e4a3e3f55904751"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffbf6826b2a3db5ab86537c276491cd69bf293e5d8d971036a6b0f70ef52fcf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00a1b8a9b43056c2995c4169e6e1e38d8a26a1f5b1b4f5289a4803d58cb77532"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0cbfcbb7222d26fb2cf38b655f563120351951c804808169a8d07db687f7afb"
    sha256 cellar: :any_skip_relocation, sonoma:         "2bbdae86092134f1d02fe791ce9ab616aad1c2062429fbd0c824726ba9786d31"
    sha256 cellar: :any_skip_relocation, ventura:        "2b254cb84a9bb770e78323c4f5a66b124c04cace964e49e8f58d9974eb15b93d"
    sha256 cellar: :any_skip_relocation, monterey:       "dfdc1fe033cb83f924e5191c1515c87f39e13f59e33c743a4d50ea8e95730a80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ab23b392e6216e921bbad709c38dc642d6293dd4b623a2a66e8b9e152ba4ef1"
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
