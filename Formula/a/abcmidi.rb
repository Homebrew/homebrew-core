class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2026.02.24.zip"
  sha256 "184507de03e7401430785e73f988a2f01533ccadaac7707a0291402c98580c9f"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a3a07a60e49c12005bffec31732154d8804869cc613860cf6abc29ec29930f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "034291d14fb628c46a745421fee0b91eae81dc006e523c72cf6df116b664a09d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbccbb1ce2da8e3d1c51e8638375240ae61afcca6cef540b78e9e4e4c48a7088"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0617dee6d9b27d0555b3e222862dc601227b88b525d5d72b99dfc5a7b060c39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ab7a8616d14df1a830f10bc256190abd4db2de6ab3ea042823411dbdc1e95a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d9f98827b6310a4cabc2805420e9b8020b5b196450dec5622a804b2204cdaf1"
  end

  def install
    system "./configure", *std_configure_args
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

    system bin/"abc2midi", testpath/"balk.abc"
  end
end
