class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2023.06.25.zip"
  sha256 "0521cb35472a08c2af21de080488e763faf4ecd1dc4adf1a3b017c5011f88b57"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "911a0800ff4a550ea40ff6204f2963ea77a7707385088ad2f4400ff0e9cbf394"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "946ee3a669030bf5f46df950790867fe8fbc13b97ad68058b2262af130284cea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d8a01c9ff102954eae279ef4079f8912b49eaf123c7b7e5bf422a0bb3e5c1ec"
    sha256 cellar: :any_skip_relocation, ventura:        "132480a8ded6de38e48217e0e205b15ef37cefe920ead4903081c56a1f8925cf"
    sha256 cellar: :any_skip_relocation, monterey:       "0f1ac43fd05d8328af23275576f1346561ae8f2f3dcab789a40ee49b4641074a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7769ab9f252e77886ab2a93a88e3aea60bfe39c9c13a2a23fab6144c1846e2c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a66244ad5578c92747ed60ae5fa0b7bf3a342d01f9fef794e5ca82f6284efa0d"
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
