class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2022.01.13.zip"
  sha256 "b19ab69ab2973719c6bd24c3aa922059be2b45a8fb015c95968ad3cc8259d5d0"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "503e458d0d80db9e5b03abb2e920a7e16ce8d0660c124f82fdf42171dbe5ae3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "323ce56667bfb30c321d699ab0da09a00bf1c5b78f9a9d929da7c508e4132278"
    sha256 cellar: :any_skip_relocation, monterey:       "e51306c9f66493c43f62da0e74337fecd9697c1574465f551a768fb3637f6327"
    sha256 cellar: :any_skip_relocation, big_sur:        "03fa0136e255b1324b362d1af4911dc14a3be836df62e1c6764e3eb4bfac0344"
    sha256 cellar: :any_skip_relocation, catalina:       "e3fd62d576b03f2f60cafce31aceda3157f2f0c1b4c5951ccca5c5e339e26ec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f769ec138e090586439d6ef2204253787b9c4b0e9c3e4c386a80c0602fb4defd"
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
