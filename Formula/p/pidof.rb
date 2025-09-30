class Pidof < Formula
  desc "Display the PID number for a given process name"
  # `nightproductions.net` is no longer accessible, use internet archive urls instead.
  homepage "https://web.archive.org/web/20240808152721/http://www.nightproductions.net/cli.htm"
  url "https://web.archive.org/web/20240808152721/http://www.nightproductions.net/downloads/pidof_source.tar.gz"
  mirror "https://distfiles.macports.org/pidof/pidof_source.tar.gz"
  version "0.1.4"
  sha256 "2a2cd618c7b9130e1a1d9be0210e786b85cbc9849c9b6f0cad9cbde31541e1b8"
  license :cannot_represent

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a4a39bf5d7afe77664897dcd7eb1eb696554d932724b266fd0ff54b8f9a7602b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4ec5871a736544b3d218e48cb3883ae457aa097eb0b9a37e666d069d00080fb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b066475e9ddce61ef79c68b32e46f173c2c8c685a7269f30fb966efc137bccd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "964d09783be4f829eeac50a16939ba0f289fa2c88dc7fba155f258683f009884"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b299aebe4224da62d4f287f46a6816362986a9a78089c3315ab2c4e2f946420"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7d1943e3d14377270554f16198f105b0e00cc9d53da79c7d22bc7974b711a23"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6282b449ff80b52362718d1fc34cdcb13ee00a570fbd0897a8a171040f5022b"
    sha256 cellar: :any_skip_relocation, ventura:        "0accd2ab3d57c68efa55bd50dfc7c5343ce1da7f6c9e76d534a6d6a234209973"
    sha256 cellar: :any_skip_relocation, monterey:       "1509f0473f6860e3836d43ed83f594982c3e4aa4af5b2a6be3f69ee55e1f74d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3a5a73563d4ca6e329d293423f19639e98151ec72505fb926b00eab067cac55"
    sha256 cellar: :any_skip_relocation, catalina:       "634f42559aaa0582a6700c268737ba7cb7ec3bdadf2f3aa37c5a846604759459"
  end

  # `nightproductions.net` is no longer accessible
  deprecate! date: "2025-01-12", because: :repo_removed

  # Hard dependency on sys/proc.h, which isn't available on Linux
  depends_on :macos

  def install
    # Fix "error: call to undeclared function 'strcasestr'" and "error: call to undeclared function 'kill'"
    # Contacted the upstream author via email on 2023-09-29
    inreplace "pidof.c",
              "#import <stdarg.h>\n",
              "#import <stdarg.h>\n#import <string.h>\n#import <signal.h>\n"

    system "make", "all", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    man1.install Utils::Gzip.compress("pidof.1")
    bin.install "pidof"
  end

  test do
    assert_match "pidof version #{version}", shell_output("#{bin}/pidof -v")
    (testpath/"homebrew_testing.c").write <<~C
      #include <unistd.h>
      #include <stdio.h>

      int main()
      {
        printf("Testing Pidof\\n");
        sleep(10);
        return 0;
      }
    C
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
