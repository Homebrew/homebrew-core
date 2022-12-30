class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2022.12.30.zip"
  sha256 "3ed08642ca3100ec48fe7b5a870a650596a8454fbb4992654ead746e9211ce01"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e96fa4d98bd388b9ba702412a810f8d4c678cf687d0a307476822c60b4daa78b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17170d8bbe02fa98c5d3d2e48934ff181b832d4cc39b7a761e348eeeeab238bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6cd27ef5ff4bc83bc6c65e31ca4adff0ea8326237b9b5e8d855fdaa18911e7b"
    sha256 cellar: :any_skip_relocation, ventura:        "ccd57cbbaac0202c550080c16ad6553d1ef4dfd6b69e928a114acfe4415c89bc"
    sha256 cellar: :any_skip_relocation, monterey:       "149c1bf360d77c3b8f8fbedfb519eee3a7050209100d3b7a4c9efdbfa9dde51d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d69072757d2a3d380e7895e8e600b127dfb0a020b5686621fd715c579eead7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7756bc950b17b05271361e2ec928b74ddeef0dffcf5f821daae9227c7770bfc"
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
