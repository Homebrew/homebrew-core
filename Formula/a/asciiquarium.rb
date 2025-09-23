class Asciiquarium < Formula
  desc "Aquarium animation in ASCII art"
  homepage "https://robobunny.com/projects/asciiquarium/html/"
  url "https://robobunny.com/projects/asciiquarium/asciiquarium_1.1.tar.gz"
  sha256 "1b08c6613525e75e87546f4e8984ab3b33f1e922080268c749f1777d56c9d361"
  license "GPL-2.0-or-later"
  revision 5

  livecheck do
    url "https://robobunny.com/projects/asciiquarium/"
    regex(/href=.*?asciiquarium[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "c8d27e98633a1e5c8824aee48999c9d5ba0fa06da02b268772fcf8e7b6a9e492"
    sha256 cellar: :any,                 arm64_sequoia:  "080079f96aa210857f68ea0e376ce057dca85875e94df0a2da695559d37d08e9"
    sha256 cellar: :any,                 arm64_sonoma:   "059912db660f5e55c48c425c6c227f9122d02055e13bdaf1633ce39e0a4f575e"
    sha256 cellar: :any,                 arm64_ventura:  "6f9aa92e662714c05c5abebf715071a583eafdc0f639a1d0230a66043d28d088"
    sha256 cellar: :any,                 arm64_monterey: "025b86916160e616180c3c84e58dbe678dafc777704d66ce9d7a2ba07df5241e"
    sha256 cellar: :any,                 sonoma:         "821f581063ff102904f53455f6f7c412e060a0da3be1563dae89fe592b613986"
    sha256 cellar: :any,                 ventura:        "d1774d0ec6069c399b4a40e49e7f98f7df94fa51b3f6ddd3a402e14c96c34f2b"
    sha256 cellar: :any,                 monterey:       "0e107b8988ca4b01b6a7df53abb9fd894447836f3bca8af95528c5a26ca1da76"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1038d221610a6828fff3e680fa8a32142b5a731c6b19ee5a4ff87f8c86317c45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c07d0ae91d74691fa184d850d1444412042d9302d52ef44c37f14ab6f00cb433"
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
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

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
      output = begin
        stdout.gets
      rescue Errno::EIO
        nil
      end
      assert_match "\e[?10", output[0..4]
    end
  end
end
