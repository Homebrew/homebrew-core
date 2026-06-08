class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2026.06.06.zip"
  sha256 "6e895116d4fb17d679d166234966bf31e0f4ec0043d94027a9f003c427cbbb94"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77556970e60930fc282492d6712ee22deb9ff27b98ddcbbd548cf6e505c903f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71053439084a390546130076063360b892c17204f03d64823de1ded1bb95d953"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd924797fc078805fd3591bc1dc9d6581a4ca5a241a903d89a0a8d82f86f9606"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e4988460b17fc041f429fb8dfe56d89c9b203b58d04927810d30b552af242cb"
    sha256 cellar: :any,                 arm64_linux:   "41d0f2ee013f9ca9a4b40becdb3c99f3c35cee6c02efb30205cb969a4fc9c8ae"
    sha256 cellar: :any,                 x86_64_linux:  "f38c6d974fc6aa227af3b115182bed2639dbcfa3496cc7de8670ca46ade24169"
  end

  deny_network_access!

  def install
    # Work around incompatible function pointer types with newer Clang
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

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
