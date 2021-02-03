class Avian < Formula
  desc "Lightweight VM and class library for a subset of Java features"
  homepage "https://readytalk.github.io/avian/"
  url "https://github.com/ReadyTalk/avian/archive/v1.2.0.tar.gz"
  sha256 "e3639282962239ce09e4f79f327c679506d165810f08c92ce23e53e86e1d621c"
  license "ISC"
  head "https://github.com/ReadyTalk/avian.git"

  bottle do
    rebuild 1
    sha256 cellar: :any, mojave:      "07a5c761ffc3bc57db4a5b0dbd952a47fcb2b62f1083eee3106be50031adfa5e"
    sha256 cellar: :any, high_sierra: "ee881641717eed4a61ab64f832ab420401ed7a814fd32e546ae0765b5b27de6b"
    sha256 cellar: :any, sierra:      "ef092ec60093190857b558fd9a663ca0c6d0356bb9af7798be21cf466678f27e"
    sha256 cellar: :any, el_capitan:  "d2719509725f4c1fad3a53c32de18aff5d45685fb35ae352f1d51fc61e566f4a"
    sha256 cellar: :any, yosemite:    "d002876c03742fc7ec4157fff598e7c11ed1e62f97ce1b217f8b089db87e43ed"
    sha256 cellar: :any, mavericks:   "20dd7125d138e05021b473d026190d8f4652e807afcfe057614e5c2e66ce0ed1"
  end

  deprecate! date: "2020-11-12", because: :unmaintained

  depends_on "openjdk@8"

  uses_from_macos "zlib"

  def install
    system "make", "use-clang=true"
    bin.install Dir["build/macosx-*/avian*"]
    lib.install Dir["build/macosx-*/*.dylib", "build/macosx-*/*.a"]
  end

  test do
    (testpath/"Test.java").write <<~EOS
      public class Test {
        public static void main(String arg[]) {
          System.out.print("OK");
        }
      }
    EOS
    system "javac", "Test.java"
    assert_equal "OK", shell_output("#{bin}/avian Test")
  end
end
