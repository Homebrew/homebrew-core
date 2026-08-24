class Asciiquarium < Formula
  desc "Aquarium animation in ASCII art"
  homepage "https://robobunny.com/projects/asciiquarium/html/"
  url "https://robobunny.com/projects/asciiquarium/asciiquarium_1.1.tar.gz"
  sha256 "1b08c6613525e75e87546f4e8984ab3b33f1e922080268c749f1777d56c9d361"
  license "GPL-2.0-or-later"
  revision 7

  livecheck do
    url "https://robobunny.com/projects/asciiquarium/"
    regex(/href=.*?asciiquarium[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ebc54810e56523c2123684e5545afe93c8cdd6f723b53142c7e9fac508ae71e7"
    sha256 cellar: :any, arm64_sequoia: "dc7d7818866d54974751f18f9718751a34aa2d6101f2f15780ab26f874d0d409"
    sha256 cellar: :any, arm64_sonoma:  "98559ef65c4e2af4e14ea1d2ef7e0b4f0d1fea65ead318562ed61601873bf9be"
    sha256 cellar: :any, sonoma:        "b7d8dd2e459fbc17a9377e6314e63dc7ae33a321cfec0135dd834aa6665a4ae4"
    sha256 cellar: :any, arm64_linux:   "462fde5700c9aabe1b3d4d12e51dd4b31fda33019dd057bbb135584ffdb95cd3"
    sha256 cellar: :any, x86_64_linux:  "c12b30a0628118b53ea655f55b1067ec530be5f748177f5ef07469fca8cf0f5c"
  end

  depends_on "ncurses"
  uses_from_macos "perl"

  resource "Curses" do
    url "https://cpan.metacpan.org/authors/id/G/GI/GIRAFFED/Curses-1.45.tar.gz"
    sha256 "84221e0013a2d64a0bae6a32bb44b1ae5734d2cb0465fb89af3e3abd6e05aeb2"
  end

  resource "Term::Animation" do
    url "https://cpan.metacpan.org/authors/id/K/KB/KBAUCOM/Term-Animation-2.6.tar.gz"
    sha256 "7d5c3c2d4f9b657a8b1dce7f5e2cbbe02ada2e97c72f3a0304bf3c99d084b045"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    chmod 0755, "asciiquarium"
    bin.install "asciiquarium"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    # This is difficult to test because:
    # - There are no command line switches that make the process exit
    # - The output is a constant stream of terminal control codes
    # - Testing only if the binary exists can still result in failure

    # The test process is as follows:
    # - Spawn the process capturing stdout and the pid
    # - Kill the process after there is some output
    # - Ensure the start of the output matches what is expected

    require "pty"
    ENV["TERM"] = "xterm"
    PTY.spawn(bin/"asciiquarium") do |stdout, stdin, _pid|
      sleep 5
      stdin.write "q"
      output = []
      begin
        stdout.each_char { |char| output << char }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
      assert_match "\e[?10", output[0..4].join
    end
  end
end
