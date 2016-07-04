class Mg3a < Formula
  desc "Small Emacs-like editor inspired like mg with UTF8 support"
  homepage "http://www.bengtl.net/files/mg3a/"
  url "http://www.bengtl.net/files/mg3a/mg3a.160609.tar.gz"
  sha256 "006aee36be4a0558ea1ab386d18b128b3300b607ab36facc04ce5a6b1121ab23"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbb8f6bb062b4861ebd18264df69476b72d0d0bfb2a023a340fff903e98c36d6" => :el_capitan
    sha256 "f91578661287817f8acf971499917ada99600dff666d916b2fc7b2a33c1d765f" => :yosemite
    sha256 "272e4968b831d13ca41ba0abc342f73f24197a65c535f0c1add6e33981363c5a" => :mavericks
  end

  conflicts_with "mg", :because => "both install `mg`"

  option "with-c-mode", "Include the original C mode"
  option "with-clike-mode", "Include the C mode that also handles Perl and Java"
  option "with-python-mode", "Include the Python mode"
  option "with-most", "Include c-like and python modes, user modes and user macros"
  option "with-all", "Include all fancy stuff"

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
