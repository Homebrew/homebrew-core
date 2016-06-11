class Mg3a < Formula
  desc "Small Emacs-like editor inspired like mg with UTF8 support"
  homepage "http://www.bengtl.net/files/mg3a/"
  url "http://www.bengtl.net/files/mg3a/mg3a.160511.tar.gz"
  sha256 "1281e31930216565cf6572e05064e06fcbf64074f9ebf4677ef0e4b22fbf21f8"

  bottle do
    cellar :any_skip_relocation
    sha256 "62ae10d29c7f8b9df0ea3f2d6ba76ac11ca2afa27c1bac68eb5328fd941bd67c" => :el_capitan
    sha256 "0739510b46503faecb3793d9a230d33a283b17dfc3b208087d2fb44e6e9fbe67" => :yosemite
    sha256 "334f8cafe8d0410aab5a07d99d530babdccffa1f63fdc6286b947dce87ef9222" => :mavericks
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
