class AbiComplianceChecker < Formula
  desc "Tool for checking backward API/ABI compatibility of a C/C++ library"
  homepage "https://lvc.github.io/abi-compliance-checker/"
  url "https://github.com/lvc/abi-compliance-checker/archive/refs/tags/2.3.tar.gz"
  sha256 "b1e32a484211ec05d7f265ab4d2c1c52dcdb610708cb3f74d8aaeb7fe9685d64"
  license "LGPL-2.1-or-later"
  head "https://github.com/lvc/abi-compliance-checker.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "06af34b7632a01e00b3d6d5ad826d4102e7a840e32b4a0a0bc2a58c3fc799cef"
  end

  deprecate! date: "2024-06-05", because: :unmaintained
  disable! date: "2025-06-21", because: :unmaintained

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
    assert_path_exists testpath/"compat_reports/foo/1.0_to_2.0/compat_report.html"
  end
end
