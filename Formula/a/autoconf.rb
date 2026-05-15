class Autoconf < Formula
  desc "Automatic configure script builder"
  homepage "https://www.gnu.org/software/autoconf/"
  url "https://ftpmirror.gnu.org/gnu/autoconf/autoconf-2.73.tar.gz"
  mirror "https://ftp.gnu.org/gnu/autoconf/autoconf-2.73.tar.gz"
  sha256 "259ddfa3bddc799cfb81489cc0f17dfdf1bd6d1505dda53c0f45ff60d6a4f9a7"
  license all_of: [
    "GPL-3.0-or-later",
    "GPL-3.0-or-later" => { with: "Autoconf-exception-3.0" },
  ]
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc785e044f4bec3efa3e9875f154905dad8a249e6e57d2a3ab0250eebdc866e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc785e044f4bec3efa3e9875f154905dad8a249e6e57d2a3ab0250eebdc866e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc785e044f4bec3efa3e9875f154905dad8a249e6e57d2a3ab0250eebdc866e8"
    sha256 cellar: :any_skip_relocation, tahoe:         "bc785e044f4bec3efa3e9875f154905dad8a249e6e57d2a3ab0250eebdc866e8"
    sha256 cellar: :any_skip_relocation, sequoia:       "bc785e044f4bec3efa3e9875f154905dad8a249e6e57d2a3ab0250eebdc866e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc785e044f4bec3efa3e9875f154905dad8a249e6e57d2a3ab0250eebdc866e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "774b52ebda38e5562f3ee18bbb1f2d48fe5c89c308f0b8b34c368f1ccd856572"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "774b52ebda38e5562f3ee18bbb1f2d48fe5c89c308f0b8b34c368f1ccd856572"
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
