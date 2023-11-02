class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2023.11.01.zip"
  sha256 "95d033f37f809c4687f130bb3e2f5523d6dd8bef467d51fb09eea4566bc95240"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0dcdf97a1673bc01da139c53a9273aa9fe631d9eacc306e667e4bb4fccd1bc7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "feddbef0b04cd3ce6488948c6300fa46741e817c881fe8b0b762b6a1e55c47d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7186a2829c0964740a11aa3c2decc9b30b633a48bd27e769965e52d68b65ec46"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e121c8afe5e76cca4a7cafed492ad600819dd5cf2930d6b6a2b6e03eb9f5ead"
    sha256 cellar: :any_skip_relocation, ventura:        "e24e3d7274046e89676f6de46dc0611475f806086551100650d81a31bf68387a"
    sha256 cellar: :any_skip_relocation, monterey:       "afe75ddfa949f031d8f8eb0abfc49d09a73fe8cfef073889a4d6d07fe45c4783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ea459bd21c543e36674e73dc21073edf990b862fd90ae4ed8e263adca2b9e44"
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
