class Automake < Formula
  desc "Tool for generating GNU Standards-compliant Makefiles"
  homepage "https://www.gnu.org/software/automake/"
  url "https://ftp.gnu.org/gnu/automake/automake-1.18.tar.xz"
  mirror "https://ftpmirror.gnu.org/automake/automake-1.18.tar.xz"
  sha256 "5bdccca96b007a7e344c24204b9b9ac12ecd17f5971931a9063bdee4887f4aaf"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf9250abf354e8df5599dff2ee55ca457910868623ce1687c0573580fb810eb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf9250abf354e8df5599dff2ee55ca457910868623ce1687c0573580fb810eb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf9250abf354e8df5599dff2ee55ca457910868623ce1687c0573580fb810eb9"
    sha256 cellar: :any_skip_relocation, sequoia:       "228f799a70023d702f770919a1d3d13a79291c48b72247b6722c7fa3682a81a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "228f799a70023d702f770919a1d3d13a79291c48b72247b6722c7fa3682a81a9"
    sha256 cellar: :any_skip_relocation, ventura:       "228f799a70023d702f770919a1d3d13a79291c48b72247b6722c7fa3682a81a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16c798f7c786e7be9c7e1b8f6daa56680c1b301a36bc13815e492553fedaf700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16c798f7c786e7be9c7e1b8f6daa56680c1b301a36bc13815e492553fedaf700"
  end

  depends_on "autoconf"

  def install
    ENV["PERL"] = "/usr/bin/perl" if OS.mac?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    # Our aclocal must go first. See:
    # https://github.com/Homebrew/homebrew/issues/10618
    (share/"aclocal/dirlist").write <<~EOS
      #{HOMEBREW_PREFIX}/share/aclocal
      /usr/share/aclocal
    EOS
  end

  test do
    (testpath/"test.c").write <<~C
      int main() { return 0; }
    C
    (testpath/"configure.ac").write <<~EOS
      AC_INIT(test, 1.0)
      AM_INIT_AUTOMAKE
      AC_PROG_CC
      AC_CONFIG_FILES(Makefile)
      AC_OUTPUT
    EOS
    (testpath/"Makefile.am").write <<~EOS
      bin_PROGRAMS = test
      test_SOURCES = test.c
    EOS
    system bin/"aclocal"
    system bin/"automake", "--add-missing", "--foreign"
    system "autoconf"
    system "./configure"
    system "make"
    system "./test"
  end
end
