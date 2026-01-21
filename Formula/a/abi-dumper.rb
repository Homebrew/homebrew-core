class AbiDumper < Formula
  desc "Dump ABI of an ELF object containing DWARF debug info"
  homepage "https://github.com/lvc/abi-dumper"
  url "https://github.com/lvc/abi-dumper/archive/refs/tags/1.2.tar.gz"
  sha256 "8a9858c91b4e9222c89b676d59422053ad560fa005a39443053568049bd4d27e"
  license "LGPL-2.1-or-later"
  head "https://github.com/lvc/abi-dumper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "dfe5724c38317949620260b45f44131625434adb3ba62f2b4c778f7f87c409e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4e69d56bf0f10ea4b9f0bea25e8a860823ff0f08846cea20ca1212f06b9d09b5"
  end

  deprecate! date: "2024-06-05", because: :unmaintained
  disable! date: "2025-06-21", because: :unmaintained

  depends_on "abi-compliance-checker"
  depends_on "elfutils"
  depends_on :linux
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
