class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2026.04.26.zip"
  sha256 "eb17e3d0fe659f4465bbdf5dfe8f56e6a71e1ef41e664e4c40dc2dd31375026f"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cda7cc5ac343010b49ed96e8e4fb2c948b3d6d0102189c8064c9c3858c03d3ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "883b256a2beae9d30e057f5a5f2fc611ea31616079119c56752e8141c5b32284"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73332714da4fa3ddff5900a2791524e95318f0c174970277d2469819542afbe9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5f94b056e065c1d3864c3aa120f4149d6d7e7896ae2fff483bb46688ccef4f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fde65f3474418d0a052f79fae7b87a9a29127b8ff37261af5a83e3a702423d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8379b252f578ccfc617b4368862f0d08bc72ff1d7ecd0d1b13488915d294ee1"
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
