class AbiComplianceChecker < Formula
  desc "Tool for checking backward API/ABI compatibility of a C/C++ library"
  homepage "https://lvc.github.io/abi-compliance-checker/"
  url "https://github.com/lvc/abi-compliance-checker/archive/2.3.tar.gz"
  sha256 "b1e32a484211ec05d7f265ab4d2c1c52dcdb610708cb3f74d8aaeb7fe9685d64"
  license "LGPL-2.1-or-later"
  head "https://github.com/lvc/abi-compliance-checker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "b5d622c9b96aaa8fb78ec2702165ba666d881e6188a0a10bb6b941d1107fcde7"
    sha256 cellar: :any_skip_relocation, big_sur:      "b5d622c9b96aaa8fb78ec2702165ba666d881e6188a0a10bb6b941d1107fcde7"
    sha256 cellar: :any_skip_relocation, catalina:     "b5d622c9b96aaa8fb78ec2702165ba666d881e6188a0a10bb6b941d1107fcde7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cfb5f27462a33947ebc2ab18f8a5106446aaaf4322e07556f389df144a9e9d05"
  end

  uses_from_macos "perl"

  on_macos do
    # abi-compliance-checker can read only x86_64 Mach-O files.
    # https://github.com/lvc/abi-compliance-checker/issues/116
    depends_on arch: :x86_64
    depends_on "gcc"
  end

  on_linux do
    depends_on "universal-ctags"
  end

  def install
    system "perl", "Makefile.pl", "-install", "-prefix", prefix
    (bin/"abi-compliance-checker.cmd").unlink if OS.mac?

    # Make bottles uniform
    inreplace pkgshare/"modules/Internals/SysFiles.pm", "/usr/local", HOMEBREW_PREFIX
  end

  test do
    args = []
    args << "--gcc-path=gcc-#{Formula["gcc"].any_installed_version.major}" if OS.mac?
    system bin/"abi-compliance-checker", *args, "-test"

    (testpath/"foo.c").write "int foo(void) { return 0; }"
    (testpath/"include/foo.h").write "int foo(void);"
    (testpath/"lib").mkpath

    system ENV.cc, "-shared", "foo.c", "-o", testpath/"lib"/shared_library("libfoo", "1.0")
    system ENV.cc, "-shared", "foo.c", "-o", testpath/"lib"/shared_library("libfoo", "2.0")

    [1, 2].each do |v|
      (testpath/"foo.#{v}.xml").write <<~XML
        <version>
            #{v}.0
        </version>
        <headers>
            #{testpath}/include/
        </headers>
        <libs>
            #{testpath}/lib/
        </libs>
      XML
    end

    system bin/"abi-compliance-checker", *args, "-lib", "foo", "-old", "foo.1.xml", "-new", "foo.2.xml"
    assert_predicate testpath/"compat_reports/foo/1.0_to_2.0/compat_report.html", :exist?
  end
end
