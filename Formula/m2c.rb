class M2c < Formula
  desc "Modula-2 to C compiler"
  homepage "https://savannah.nongnu.org/projects/m2c/"
  url "https://download.savannah.gnu.org/releases/m2c/0.7/m2c-0.7.tar.gz"
  sha256 "b725ed617f376e1a321e059bf1985098e950965d5edab161c6b24526f10a59bc"
  head "http://git.savannah.gnu.org/cgit/m2c.git"

  bottle do
    sha256 "e98a99fb06c6b72bd0cf11d8369df21e1e9e57253e0a9d63ae8641444079df93" => :sierra
    sha256 "4aa6ac4f5fd855f4f84d5577ff6f79495fda9edc2ce5335c64bd96a881975eb0" => :el_capitan
    sha256 "67659bd6a5fe922c1b34d5068a5cecbfee1f804e5ff432e32c8682a04029ccac" => :yosemite
    sha256 "7bf62153eeb0976851785db04e1319f745709294aa9d0bc99e47ffee3eba1315" => :mavericks
    sha256 "6db02ad1e1a355edfd1770d29952812baac666d6d2a7d3a599357f796eb7d891" => :mountain_lion
  end

  # Hacks purely for this 0.7 release. Git head already fixes installation glitches.
  # Will remove hacks on release of next version.
  def install
    # The config for "gcc" works for clang also.
    cp "config/generic-gcc.h", "config/generic-clang.h"
    system "./configure", "+cc=#{ENV.cc}"

    # Makefile is buggy!
    inreplace "Makefile", "install: all uninstall", "install: all"
    inreplace "Makefile", "mkdir", "mkdir -p"
    include.mkpath

    system "make", "install", "prefix=#{prefix}", "man1dir=#{man1}"
  end

  test do
    hello_mod = "Hello.mod"
    hello_exe = testpath/"Hello"

    (testpath/hello_mod).write <<-EOF.undent
      MODULE Hello;

      FROM InOut IMPORT
        WriteLn, WriteString;

      BEGIN
        WriteString ("Hello world!");
        WriteLn;
      END Hello.
    EOF

    system "#{bin}/m2c", "-make", hello_mod, "-o", hello_exe

    assert_equal "Hello world!\n", shell_output(hello_exe)
  end
end
