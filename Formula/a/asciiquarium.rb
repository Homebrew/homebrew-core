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

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "4b32a2ef9eccd44115dbbbf648622b9148932d3846ed842b9091d50fe73d0e85"
    sha256 cellar: :any,                 arm64_sequoia: "aaa66f4be6401098af1104b81f2e05f870701b9892459c6f2fe4fc29acaf069e"
    sha256 cellar: :any,                 arm64_sonoma:  "7bfb5f807029ce81b3431b08e2ec86d192caa227ff93a7dedf3ae63e2994f9df"
    sha256 cellar: :any,                 sonoma:        "a9afe38c263f5370a0bcc6ac41bbaebee22d23bb52ff128cd9a6855fe1fbaafe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60b613a92e9ed7968fdc494724884349c644d03a8d763f8ed3abc15f65c42ec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b82f3ffd2fd47e88de054aa7d0569bf0a817be6a11017e8739cf7e014eb7681"
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
