class Mg3a < Formula
  desc "Small Emacs-like editor inspired like mg with UTF8 support"
  homepage "http://www.bengtl.net/files/mg3a/"
  url "http://www.bengtl.net/files/mg3a/mg3a.160817.tar.gz"
  sha256 "c6d65a189579e6c4ccc54b5c609690a4d1fba0b85063b14b887703950992b573"

  bottle do
    cellar :any_skip_relocation
    sha256 "efaab1a2a7060dd794d2f269edbd1d65d42c3034a0642ad238e16b552d4b3c93" => :el_capitan
    sha256 "09af09f4005e7a4d3bdc04e500ed32da4a2bdbdca9b51d080e7a256dddcc4d20" => :yosemite
    sha256 "fe45288bfcbf758b20e2febc16111e775f8b908ebd960a9f2fd4b5a8a4ccec95" => :mavericks
  end

  option "with-c-mode", "Include the original C mode"
  option "with-clike-mode", "Include the C mode that also handles Perl and Java"
  option "with-python-mode", "Include the Python mode"
  option "with-most", "Include c-like and python modes, user modes and user macros"
  option "with-all", "Include all fancy stuff"

  conflicts_with "mg", :because => "both install `mg`"

  def install
    if build.with?("all")
      mg3aopts = "-DALL" if build.with?("all")
    else
      mg3aopts = %w[-DDIRED -DPREFIXREGION -DUSER_MODES -DUSER_MACROS]
      mg3aopts << "-DLANGMODE_C" if build.with?("c-mode")
      mg3aopts << "-DLANGMODE_PYTHON" if build.with?("python-mode") || build.with?("most")
      mg3aopts << "-DLANGMODE_CLIKE" if build.with?("clike-mode") || build.with?("most")
    end

    system "make", "CDEFS=#{mg3aopts * " "}", "LIBS=-lncurses", "COPT=-O3"
    bin.install "mg"
    doc.install Dir["bl/dot.*"]
    doc.install Dir["README*"]
  end

  test do
    (testpath/"command.sh").write <<-EOS.undent
      #!/usr/bin/expect -f
      set timeout -1
      spawn #{bin}/mg
      match_max 100000
      send -- "\u0018\u0003"
      expect eof
    EOS
    (testpath/"command.sh").chmod 0755

    system testpath/"command.sh"
  end
end
