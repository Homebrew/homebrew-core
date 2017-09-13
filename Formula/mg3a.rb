class Mg3a < Formula
  desc "Small Emacs-like editor inspired by mg with UTF8 support"
  homepage "http://www.bengtl.net/files/mg3a/"
  url "http://www.bengtl.net/files/mg3a/mg3a.170403.tar.gz"
  sha256 "43a4898ce319f119fad583899d0c13a50ee6eb8115062fc388dad028eaddd2cc"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa6df4b7b8598b0a81499fb3ebfeb09233bdeac2c7150292dd6acaa9ecb787bc" => :sierra
    sha256 "4330835634faef0f93eb7340d1b6ad992669422d93210b209df28007f80658f6" => :el_capitan
    sha256 "4017a82bff19eb00a699206494bcaa456dbe70a529edd75fd80044064de26965" => :yosemite
  end

  option "with-c-mode", "Include the original C mode"
  option "with-clike-mode", "Include the C mode that also handles Perl and Java"
  option "with-python-mode", "Include the Python mode"
  option "with-most", "Include c-like and python modes, user modes and user macros"
  option "with-all", "Include all fancy stuff"

  conflicts_with "mg", :because => "both install `mg`"

  def install
    if build.with?("all")
      mg3aopts = %w[-DALL]
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
