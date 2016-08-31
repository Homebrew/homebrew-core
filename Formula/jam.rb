class Jam < Formula
  desc "Make-like build tool"
  homepage "https://www.perforce.com/resources/documentation/jam"
  url "https://swarm.workshop.perforce.com/projects/perforce_software-jam/download/main/jam-2.6.zip"
  sha256 "7c510be24dc9d0912886c4364dc17a013e042408386f6b937e30bd9928d5223c"

  bottle do
    cellar :any_skip_relocation
    sha256 "d93effb9978322bc47d7d204e435ce7da90dd577a43b9086d6868a3118c2fb29" => :el_capitan
    sha256 "9f8bffedce727f07a14ff7a9453bf66884dce87d463de464fe2c40e30f127c60" => :yosemite
    sha256 "83ef7ba772948a5e06481cd0a32c54f09139d2693d880223b72ee27deb4d7e37" => :mavericks
  end

  conflicts_with "ftjam", :because => "both install a `jam` binary"

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LOCATE_TARGET=bin"
    bin.install "bin/jam", "bin/mkjambase"
  end

  test do
    (testpath/"Jamfile").write <<-EOS.undent
      Main jamtest : jamtest.c ;
    EOS

    (testpath/"jamtest.c").write <<-EOS.undent
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
