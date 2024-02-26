class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2024.02.25.zip"
  sha256 "d2a79243d27754808da89ab36abfc9d173b9dc1fb6c4825647fed3cadc09f92c"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82d9a031e178581f07257200dc57bd761bc6c5bc3220108c624c15fc2737ec50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85257337a2554c2ee4d19b8602a439968c0a7fc087e989b57e696f547eef8075"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f3fe03cebcd6fbd67821604bffc28b4c7faf0ca2781f32af22f812369fe9eaf"
    sha256 cellar: :any_skip_relocation, sonoma:         "012847d85723a04f1b44559b5a6bb8e5b2d6571880282020d4af82fbcbc5952a"
    sha256 cellar: :any_skip_relocation, ventura:        "24e4e1dea87afea77857d73cad7d918a83fd520196cbbb4458f1ab6b2e45d4f8"
    sha256 cellar: :any_skip_relocation, monterey:       "d52b0d901918ab89ce2082e2618494d46a15ae7f2d4c51489deaaf5139f04010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fb7342277ca965e1950ed31fd01d029786c5054744b8d65c331a94d810fc50f"
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
