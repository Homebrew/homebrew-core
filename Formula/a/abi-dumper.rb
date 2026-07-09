class AbiDumper < Formula
  desc "Dump ABI of an ELF object containing DWARF debug info"
  homepage "https://github.com/lvc/abi-dumper"
  url "https://github.com/lvc/abi-dumper/archive/refs/tags/1.4.tar.gz"
  sha256 "aa7a52bf913ab1a64743551d64575f921df3faa4a592a0f6614e047bc228708a"
  license "LGPL-2.1-or-later"
  head "https://github.com/lvc/abi-dumper.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "6683098a4edbe870557bb889c3ca199ea503f8aeafd53134707ce74ad4fbe1b8"
  end

  depends_on "elfutils"
  depends_on :linux
  depends_on "perl"
  depends_on "universal-ctags"
  depends_on "vtable-dumper"

  deny_network_access!

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    testlib = testpath/shared_library("libtest")
    (testpath/"test.c").write "int foo() { return 0; }"
    system ENV.cc, "-g", "-Og", "-shared", "test.c", "-o", testlib
    system bin/"abi-dumper", testlib, "-o", "test.dump"
    assert_path_exists testpath/"test.dump"
  end
end
