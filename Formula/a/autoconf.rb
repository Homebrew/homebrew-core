class Autoconf < Formula
  desc "Automatic configure script builder"
  homepage "https://www.gnu.org/software/autoconf/"
  url "https://ftpmirror.gnu.org/gnu/autoconf/autoconf-2.72.tar.gz"
  mirror "https://ftp.gnu.org/gnu/autoconf/autoconf-2.72.tar.gz"
  sha256 "afb181a76e1ee72832f6581c0eddf8df032b83e2e0239ef79ebedc4467d92d6e"
  license all_of: [
    "GPL-3.0-or-later",
    "GPL-3.0-or-later" => { with: "Autoconf-exception-3.0" },
  ]

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3374908e36c28948511beea4bdb005556f3d3c382a1377301c9b8eba2bf8ee77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b1d110e2efd457a5e56c4469f2d6741109d542801a401fe08b750d0614581a9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3674a4dfa3794e022b1adbcd9c954c91192d38822080c7162d073d6609b903a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3674a4dfa3794e022b1adbcd9c954c91192d38822080c7162d073d6609b903a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3674a4dfa3794e022b1adbcd9c954c91192d38822080c7162d073d6609b903a"
    sha256 cellar: :any_skip_relocation, tahoe:          "3374908e36c28948511beea4bdb005556f3d3c382a1377301c9b8eba2bf8ee77"
    sha256 cellar: :any_skip_relocation, sequoia:        "a0d9eae5c0acae66c817cba6c01e872d475cd756ea6af10a7e72be27e5b80d02"
    sha256 cellar: :any_skip_relocation, sonoma:         "32c6ff07058a61e7fada66d171fee246502fcd1f5b98b65a1ef5b0acfcfa28c2"
    sha256 cellar: :any_skip_relocation, ventura:        "32c6ff07058a61e7fada66d171fee246502fcd1f5b98b65a1ef5b0acfcfa28c2"
    sha256 cellar: :any_skip_relocation, monterey:       "ab03a9de5759022fd4c341a085adc41ef34b00829a21d5f98a76538ce7ec4908"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "55fcb698584173e2d750696d104f3658dbe37fae4651dc7c72d28e6b3a2fb4e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55e5cfc7d6f3d91895fe5a345b2158498f8e96b05574b073edf667de4122413d"
  end

  depends_on "m4"
  uses_from_macos "perl"

  def install
    if OS.mac?
      ENV["PERL"] = "/usr/bin/perl"

      # force autoreconf to look for and use our glibtoolize
      inreplace "bin/autoreconf.in", "libtoolize", "glibtoolize"
      # also touch the man page so that it isn't rebuilt
      inreplace "man/autoreconf.1", "libtoolize", "glibtoolize"
    end

    system "./configure", "--prefix=#{prefix}", "--with-lispdir=#{elisp}"
    system "make", "install"

    rm(info/"standards.info")
  end

  test do
    cp pkgshare/"autotest/autotest.m4", "autotest.m4"
    system bin/"autoconf", "autotest.m4"

    (testpath/"configure.ac").write <<~EOS
      AC_INIT([hello], [1.0])
      AC_CONFIG_SRCDIR([hello.c])
      AC_PROG_CC
      AC_OUTPUT
    EOS
    (testpath/"hello.c").write "int foo(void) { return 42; }"

    system bin/"autoconf"
    system "./configure"
    assert_path_exists testpath/"config.status"
    assert_match(/\nCC=.*#{ENV.cc}/, (testpath/"config.log").read)
  end
end
