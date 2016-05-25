class Asciiquarium < Formula
  desc "Aquarium animation in ASCII art"
  homepage "http://robobunny.com/projects/asciiquarium/html/"
  url "http://www.robobunny.com/projects/asciiquarium/asciiquarium_1.1.tar.gz"
  sha256 "1b08c6613525e75e87546f4e8984ab3b33f1e922080268c749f1777d56c9d361"

  resource "Curses" do
    url "https://cpan.metacpan.org/authors/id/G/GI/GIRAFFED/Curses-1.34.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/G/GI/GIRAFFED/Curses-1.34.tar.gz"
    sha256 "808e44d5946be265af5ff0b90f3d0802108e7d1b39b0fe68a4a446fe284d322b"
  end

  resource "Term::Animation" do
    url "http://robobunny.com/projects/animation/Term-Animation.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/K/KB/KBAUCOM/Term-Animation-2.6.tar.gz"
    sha256 "7d5c3c2d4f9b657a8b1dce7f5e2cbbe02ada2e97c72f3a0304bf3c99d084b045"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    chmod 0755, "asciiquarium"
    bin.install "asciiquarium"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
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
    PTY.spawn("#{bin}/asciiquarium") do |stdin, _stdout, pid|
      sleep 0.1
      Process.kill "TERM", pid
      output = stdin.read
      assert_match "\e[?10", output[0..4]
    end
  end
end
