class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2023.01.08.zip"
  sha256 "c4d8ee93a3cdfe1efc3a029054d69d9dea426b8da36b9cb61cb9b2ff989c9b6f"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "923242c9aa7dc51bb610e93819491adbb1200128c36152c6ab465b89e4e28e98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3736459cc84eeac4a9b21e917f7e37c5eacb89674aaa9cce193c7327d4ef8bfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef83fff433609fa55b607e6901862325faa171e3f11747534815090f8c0713c8"
    sha256 cellar: :any_skip_relocation, ventura:        "b3208d139735a2864425913225ae3bd1c5cf72ffecf99dfe7f066d0e55a4898e"
    sha256 cellar: :any_skip_relocation, monterey:       "dc65a7ad57ad6dd44e78ddb9ca213fded65c9205e42988718a13fed7ab75d119"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9607aa257ad2eb755df8348309c64cae4aa5f6ea5ed177ca8579a6dc22e5af6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a64fa02ac017cf663302e6bbf21b68ee4edcdb1c462a9de7dac2f3b2dfc753c6"
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
