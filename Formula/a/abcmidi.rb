class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2026.04.01.zip"
  sha256 "5ee2e87240315215948a40ba7e03a297171c0d902d88803a62294757fe9833a1"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0df5eee7321031cfa3fb9beea8046bc4f79b5a034caa29ab599e2676ff63cfbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c335ae99f5eb5719fd9f580bdaa0dcffe8361d4f6c5a10df3d65f58ed511877c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf74268a101a6923b1d5fb7f69b2357085537737ebdcc2188e3ffe2256809125"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ad3322aa6deddfab95b927932f25146b3abe7861c2bdf134b6e9b291aa1b8bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c729182f530a897b9c952537fd260cf45866add67028efcd24b09199da9039d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77216cac062da1c21fd618ca44bc5d7dfffb91f6c24d6bfed0efb7d5f76a6d69"
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
