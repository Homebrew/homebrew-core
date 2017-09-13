class Pidof < Formula
  desc "Display the PID number for a given process name"
  homepage "http://www.nightproductions.net/cli.htm"
  url "http://www.nightproductions.net/downloads/pidof_source.tar.gz"
  version "0.1.4"
  sha256 "2a2cd618c7b9130e1a1d9be0210e786b85cbc9849c9b6f0cad9cbde31541e1b8"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "6991d110a73724959f84edc398647e3cac5a029645daedef5f263ae51218130d" => :sierra
    sha256 "d02c826db5564d7750c0e309a771b164f7764250507955d0b87d09837c3c2ba6" => :el_capitan
    sha256 "54ffe0be6ef278aa45cacb856687df925bab1c117d1ab4c1a8f81ae835fb293e" => :mavericks
    sha256 "d79dbbb55e7103639a1bb01413115b2526940cd9a198e59da05fec304369f443" => :mountain_lion
    sha256 "ce5f3ea346e86cd98880ece0e457a5febfd48165ba947152bea9a3c459f41b3f" => :lion
  end

  def install
    system "make", "all", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    man1.install gzip("pidof.1")
    bin.install "pidof"
  end

  test do
    (testpath/"homebrew_testing.c").write <<-EOS.undent
      #include <unistd.h>
      #include <stdio.h>

      int main()
      {
        printf("Testing Pidof\\n");
        sleep(10);
        return 0;
      }
    EOS
    system ENV.cc, "homebrew_testing.c", "-o", "homebrew_testing"
    (testpath/"homebrew_testing").chmod 0555

    pid = fork { exec "./homebrew_testing" }
    sleep 1
    begin
      assert_match(/\d+/, shell_output("#{bin}/pidof homebrew_testing"))
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
