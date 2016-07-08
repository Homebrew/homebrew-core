class Mg3a < Formula
  desc "Small Emacs-like editor inspired like mg with UTF8 support"
  homepage "http://www.bengtl.net/files/mg3a/"
  url "http://www.bengtl.net/files/mg3a/mg3a.160617.tar.gz"
  sha256 "82314751f91bab86cbe0458a28ed45f93573a94c5e7cbcb3f475062761848eaa"

  bottle do
    cellar :any_skip_relocation
    sha256 "db8f9acd4b18be19f033bbfb403ac9b0783d724735dc11084ace928da78f4195" => :el_capitan
    sha256 "ddf680ef2e5f13620ce2fd290f2633b34eb8a4b193212336f45ee6d4de3b2ee5" => :yosemite
    sha256 "3fc9a38486fd70ee78932f17c920e01c29b4baca64e2b727eca5783d7630e569" => :mavericks
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
