class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2023.12.28.zip"
  sha256 "a2281437c12e3a2e91d4a8070b9c8bdfdb4ecb14e450ca0e89f469f5502ab7f8"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7ee5e6bf133f582764b804158cbcd270dde2459c440ee0bd922ae0c910eb2c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a0cc7c716bf53aef4971dfe64311efeb9218cefb9d0eb040ce8b2a931bbf03e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebbb37e314448f8df55e86bbd1cfe21d0d948b54ccbb335ecd3a34edf4c3c5f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef33c499d0548913c45d43ffa1f1e513ac94d0be76fcb77f9e5a0b8f4c8a1e0c"
    sha256 cellar: :any_skip_relocation, ventura:        "a9bcd93b222101fa7ff4b0dda9d57344c4a2b90a433ec9f3669f70add688d092"
    sha256 cellar: :any_skip_relocation, monterey:       "928b1e66d62ce62d7ddb415f3b4372167080577c6aa25d03f3dca32de3724c95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a1989dde83a74d61cc81918efd8052045066b3d2edb6bdd6a1e323ae4acfbb3"
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
