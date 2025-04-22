class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2025.02.16.zip"
  sha256 "2bbe8a6305d3708e874d3e211c831a52433ea4970bbc81d2d1ce92491c4fee5f"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc75ed523724b685d67e814ed27c69da334091ff1d3e93ec066e116b293b5ef7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77e419fa750fcb77a3b4a271c86043d2b2f6acee718790918be223672aeab4bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19a638c4f1e1a81e6263c69bb4e1b79a5d6cdb100ba042284a5605b269a4a3a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4adaa01ffef2c90fe3d9beab0469172cdcc99d3dd3c94d8dc371ef3bf69b45a"
    sha256 cellar: :any_skip_relocation, ventura:       "85de1f953827ee80b9f86eb0a85785a299d60b9ae291e0c675262e5d5324ad35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c277663417ce625cf781e21f8028073f66d97bb38277d0118836677c854d05f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "847d9f72f899f7e0191094654cfed70506e61d328c978063cd1474bb1564ffb7"
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
