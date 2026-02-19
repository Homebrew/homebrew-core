class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2026.02.18.zip"
  sha256 "67240bbf9f2ef90887bfbd2e6adf03249a5a8fe17d8758da27733acac7a2836e"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fbc16e5e91fa9f43ffb432520b281276fd5227182467547964bf230310494a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7feceeffaf426d715d090d738164b5ff6b4e5fe1f6683fcd7247428d5a40d1d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42ad07f38a8f3ae4940a927b8731baf7d309cd9ae91730da6e107d6d6a782bec"
    sha256 cellar: :any_skip_relocation, sonoma:        "42f86c273d4874b85cd3b7f3dd5f4e376a5b00ca74e8c0d66bb916526fac1993"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f1c9a26464fab89cf682281ecb5209e8c71213565e1d6354f4e49ef382f1f58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abcfa36c81845484dece3ed5d44fa3e0f0f08dcf494157ed1eaf11b653f2d761"
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
