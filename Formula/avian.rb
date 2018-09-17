class Avian < Formula
  desc "Lightweight VM and class library for a subset of Java features"
  homepage "https://readytalk.github.io/avian/"
  url "https://github.com/ReadyTalk/avian/archive/v1.2.0.tar.gz"
  sha256 "e3639282962239ce09e4f79f327c679506d165810f08c92ce23e53e86e1d621c"
  head "https://github.com/ReadyTalk/avian.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "07a5c761ffc3bc57db4a5b0dbd952a47fcb2b62f1083eee3106be50031adfa5e" => :mojave
    sha256 "ee881641717eed4a61ab64f832ab420401ed7a814fd32e546ae0765b5b27de6b" => :high_sierra
    sha256 "ef092ec60093190857b558fd9a663ca0c6d0356bb9af7798be21cf466678f27e" => :sierra
    sha256 "d2719509725f4c1fad3a53c32de18aff5d45685fb35ae352f1d51fc61e566f4a" => :el_capitan
    sha256 "d002876c03742fc7ec4157fff598e7c11ed1e62f97ce1b217f8b089db87e43ed" => :yosemite
    sha256 "20dd7125d138e05021b473d026190d8f4652e807afcfe057614e5c2e66ce0ed1" => :mavericks
  end

  depends_on :java => "1.8"
  depends_on :macos => :lion

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
