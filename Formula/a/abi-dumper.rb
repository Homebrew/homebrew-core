class AbiDumper < Formula
  desc "Dump ABI of an ELF object containing DWARF debug info"
  homepage "https://github.com/lvc/abi-dumper"
  url "https://github.com/lvc/abi-dumper/archive/refs/tags/1.4.tar.gz"
  sha256 "aa7a52bf913ab1a64743551d64575f921df3faa4a592a0f6614e047bc228708a"
  license "LGPL-2.1-or-later"
  head "https://github.com/lvc/abi-dumper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "14aca33685e8f65c9ebbdf53768ce137170dfb150ae31413b43a1b28279558c7"
  end

  depends_on "elfutils"
  depends_on :linux
  depends_on "perl"
  depends_on "universal-ctags"
  depends_on "vtable-dumper"

  def install
    # We pass `--program-prefix=elfutils-` when building `elfutils`.
    inreplace "abi-dumper.pl", "eu-readelf", "elfutils-readelf"
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
