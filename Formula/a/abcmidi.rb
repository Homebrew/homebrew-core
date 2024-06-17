class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2024.06.12.zip"
  sha256 "12f522782df8488261f96c50895ddbb75522eb92b785e8323316289b183dd0df"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7efb4f03f69e0932c8ae2c95eb494c9a75d5248fab46516d1590376b9a76df58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "191cffa5c6356c513406bb8909470db4d46faa1b127d7165afab3033e9aef58b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbf04391fc905d478e125dcb2315e563290ae693faa2953749678336568342cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "b96d5df65fdabdb33150a72893803850bc5dbd136441b8b794dc3055b76c3596"
    sha256 cellar: :any_skip_relocation, ventura:        "454f088eceebea1cf06c34542a90a7742329351d5c18e27147750d60cc11bd4e"
    sha256 cellar: :any_skip_relocation, monterey:       "8e7226a3d669a5028d3d5f363bf8f802353a74feec3b957f3f887d930c3c8b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae2f45816c2d9e3dac16de9db60a33e7fb8c1ad733cddb04e383a36e4355bf2a"
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
