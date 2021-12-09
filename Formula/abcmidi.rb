class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2021.12.05.zip"
  sha256 "bc67e955e2f058ed24b7e1f28ff527b3021bdac994bc7a8eeaa6c2048f123e15"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d69c6294b154bff0617168f140717db36722829875a7d7b2a7d619736114bd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e64505ac0e3cb7f5fa666b7457324223b1f6629589127e2daf35a681d0d9aa3e"
    sha256 cellar: :any_skip_relocation, monterey:       "4afe9a53eae8a9a9f5ba574417b947f2b7ae0af163c4dc631e222d9df1abaa50"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f24a5e91f35f9e867b818f39c29b949cbe3b5ceeed48f6ede215b7a01c29391"
    sha256 cellar: :any_skip_relocation, catalina:       "577696f965950cfc5f5c6b0fca07733ff5645d6a549ef5c91be678d72ccaba4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9ed4ab40b9fece5afac24a5442b18e105c814f710869ff999d5c3a5ecd26eb0"
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
