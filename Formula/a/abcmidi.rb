class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2026.05.12.zip"
  sha256 "05e87e35bd3520abcdf3487fac1853c08b7a54e8dc6a2d06ef66e93dd7a12eda"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be9aeaf4717c5068dfdfd79ef6773ca0e6661539d7a2492b5322d6ed99c42d64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a603aca2b298092db3a923f88becef20b19ed35feba5a81d1fd1977fd40060e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d81e937212fa0f31e80b0e53c8d9679ddd3c8b45d5208664eb36ebde37486d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "330c5496ac5119c8c89595377eff6feb170eb30f904e5a02c03e0d4ed08e5f7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "673b7e0fbf41fcae4f1739517e06705c3a4d14c9fdb3bb5c7a0b593198d4a8f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7e18e30ba126e43de705ad6de42c36f6d3222c0524ebba31eba6f8fc64d56e9"
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
