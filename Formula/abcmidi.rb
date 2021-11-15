class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2021.10.15.zip"
  sha256 "2478e2c16bf7158b107e3708fb387de26ff2e4c7a789c0dff83249962b3fc6ef"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9df0bb3860e9a1084403c85c5605bf7a3ba53522670e788073a4402d38c9762e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48672b75357d87a7e7c22fd1fbb7320917e70360fd06330e18057802cd29f27e"
    sha256 cellar: :any_skip_relocation, monterey:       "9d0ee03f7ef38182b5e43359e6e6c933a6f910ef9155bd29da89f2db9f17b51a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a799a3a2e6edf6a93c23a9113e96f5f6285598715dbd88e0ad49c9c38a4e87a2"
    sha256 cellar: :any_skip_relocation, catalina:       "c7db1bcaa8cda98fee06850dc3bf0042013f5c0d55a53c60cb840f8204ed3162"
    sha256 cellar: :any_skip_relocation, mojave:         "33ce9ba6e077c6a2e46afb8069c65c7bc1631b2f7aab9f3a97f3e366c0ff0071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b58bacfd98291e1af33b807faee2ce0ae1fe0eb84610ef06a0dcbba3accb7bc"
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
