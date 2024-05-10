class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2024.04.30.zip"
  sha256 "7cf85a598824faca3aa2159ae3d3afd4af46fae61b222e6850f53559a98456b3"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3292da7490bb46f56a1791fb4d499774df0b3dd3733dc341ec5f887f1a29358b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30c052e411b4aef8fea301050aad605ff677058553db8efca933d1aba19018ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fad8e5ff820784af873b9af59b25c997228bd4f09d8918c15904d0e82191f289"
    sha256 cellar: :any_skip_relocation, sonoma:         "85e30057a40aaa5f4dda4be40456617cc25c4828b92705351b8495a456809a16"
    sha256 cellar: :any_skip_relocation, ventura:        "80574b66cbd85e39a5123f6a42ac0a5401087adde4c306ea2ab81e4eda3e2e62"
    sha256 cellar: :any_skip_relocation, monterey:       "ee1d9bb6a01649af63edf2f233d466e7dbfbdf071d3fb541c35dcf1de3d28e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b64a01f66a3cf31e7c61b8a4a1f67419f0f4d00195c30c90a8d1f3c184134b8"
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
