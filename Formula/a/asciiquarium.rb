class Asciiquarium < Formula
  desc "Aquarium animation in ASCII art"
  homepage "https://robobunny.com/projects/asciiquarium/html/"
  url "https://robobunny.com/projects/asciiquarium/asciiquarium_1.1.tar.gz"
  sha256 "1b08c6613525e75e87546f4e8984ab3b33f1e922080268c749f1777d56c9d361"
  license "GPL-2.0-or-later"
  revision 6

  livecheck do
    url "https://robobunny.com/projects/asciiquarium/"
    regex(/href=.*?asciiquarium[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3a1be21d11ec20615ff2c00ab0e5de809faac013935caefb4806e3760371768b"
    sha256 cellar: :any,                 arm64_sequoia: "394e9653d05e18f7dd1e482fd327fd8c6ac44a924aa2ac09e3d238bc0651e7b2"
    sha256 cellar: :any,                 arm64_sonoma:  "1ff4fa17576229f515f77c9c568bd5dccf156115b280b6884436caf6b386a127"
    sha256 cellar: :any,                 sonoma:        "5170e968489608bd26069c5ea75151d67811f3555308f12009fcd6a3825bf93a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f412126cb90749fdff6d137087dc9fff2eccbe08c537b873119c1916f2b0c6fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d307a446c2b1c54a8f6b6636253479844b123ceb66a7b3b669993b29275befd2"
  end

  depends_on "ncurses"
  depends_on "perl"

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
