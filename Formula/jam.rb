class Jam < Formula
  desc "Make-like build tool"
  homepage "https://www.perforce.com/resources/documentation/jam"
  url "https://swarm.workshop.perforce.com/projects/perforce_software-jam/download/main/jam-2.6.1.zip"
  sha256 "72ea48500ad3d61877f7212aa3d673eab2db28d77b874c5a0b9f88decf41cb73"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f2f2b4cac48c2ef9b11d86867c4e9d941a41a582754bfc470da25a7174dde9f" => :catalina
    sha256 "c19a32cbe0ffa2e7d2d826ee542a74307ca29b34ba28dc5ec6aea7ff7a9127c1" => :mojave
    sha256 "2927cebface8a3cbc00a23e7badb9e1676fda9bae282e78a1772b99aafba5014" => :high_sierra
  end

  conflicts_with "ftjam", :because => "both install a `jam` binary"

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LOCATE_TARGET=bin"
    bin.install "bin/jam", "bin/mkjambase"
  end

  test do
    (testpath/"Jamfile").write <<~EOS
      Main jamtest : jamtest.c ;
    EOS

    (testpath/"jamtest.c").write <<~EOS
      #include <stdio.h>

      int main(void)
      {
          printf("Jam Test\\n");
          return 0;
      }
    EOS

    assert_match /Cc jamtest.o/, shell_output(bin/"jam").strip
    assert_equal "Jam Test", shell_output("./jamtest").strip
  end
end
