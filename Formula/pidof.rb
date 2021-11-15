class Pidof < Formula
  desc "Display the PID number for a given process name"
  homepage "http://www.nightproductions.net/cli.htm"
  url "http://www.nightproductions.net/downloads/pidof_source.tar.gz"
  version "0.1.4"
  sha256 "2a2cd618c7b9130e1a1d9be0210e786b85cbc9849c9b6f0cad9cbde31541e1b8"
  license :cannot_represent

  livecheck do
    url :homepage
    regex(/href=.*?pidof[^>]+>\s*Download \(v?(\d+(?:\.\d+)+)\)</i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b299aebe4224da62d4f287f46a6816362986a9a78089c3315ab2c4e2f946420"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7d1943e3d14377270554f16198f105b0e00cc9d53da79c7d22bc7974b711a23"
    sha256 cellar: :any_skip_relocation, monterey:       "1509f0473f6860e3836d43ed83f594982c3e4aa4af5b2a6be3f69ee55e1f74d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3a5a73563d4ca6e329d293423f19639e98151ec72505fb926b00eab067cac55"
    sha256 cellar: :any_skip_relocation, catalina:       "634f42559aaa0582a6700c268737ba7cb7ec3bdadf2f3aa37c5a846604759459"
    sha256 cellar: :any_skip_relocation, mojave:         "1a88c923954c4511fb64fe6cbfb27f5248c39d1676053c671ab71c652a377a2f"
    sha256 cellar: :any_skip_relocation, high_sierra:    "fd5f89cf3a9685142e08a23980d9438e961096d74ee508a96ccbaecb55da6e1a"
    sha256 cellar: :any_skip_relocation, sierra:         "6991d110a73724959f84edc398647e3cac5a029645daedef5f263ae51218130d"
    sha256 cellar: :any_skip_relocation, el_capitan:     "d02c826db5564d7750c0e309a771b164f7764250507955d0b87d09837c3c2ba6"
  end

  # Hard dependency on sys/proc.h, which isn't available on Linux
  depends_on :macos

  def install
    system "make", "all", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    man1.install gzip("pidof.1")
    bin.install "pidof"
  end

  test do
    (testpath/"homebrew_testing.c").write <<~EOS
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
