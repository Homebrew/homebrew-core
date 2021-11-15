require "language/perl"

class Asciiquarium < Formula
  include Language::Perl::Shebang

  desc "Aquarium animation in ASCII art"
  homepage "https://robobunny.com/projects/asciiquarium/html/"
  url "https://robobunny.com/projects/asciiquarium/asciiquarium_1.1.tar.gz"
  sha256 "1b08c6613525e75e87546f4e8984ab3b33f1e922080268c749f1777d56c9d361"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url "https://robobunny.com/projects/asciiquarium/"
    regex(/href=.*?asciiquarium[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6935116efa2d44d7bfdbbf1957982846a93b8918e5f787cdeeb8a681d8bf1e15"
    sha256 cellar: :any,                 arm64_big_sur:  "8c9d6bd3efb4262f656cfc13688ab05f0170ef2722bed28a77e0857c2473750a"
    sha256 cellar: :any,                 monterey:       "e69ea78fb241e66ab96b7901584ac17e6de805733fee4782414296fadd6c1ff5"
    sha256 cellar: :any,                 big_sur:        "ed80b66a1dad41855acd00b13b9c0d038f5bd3d8aaf59a7875bf5f317d38bb11"
    sha256 cellar: :any,                 catalina:       "cfd54b1753a801f6d6e74bcebd384e9d8b1dd9a51eb5271ff0a76e0d392c41fa"
    sha256 cellar: :any,                 mojave:         "1e50254a2473ef040dafa627205372aad2077fcbd04c8e062fe92344c9936eeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad3d1c9523192031f36ff1699cf759276f99b1810164c65cc49c0de7dd58cf67"
  end

  depends_on "ncurses"
  depends_on "perl"

  resource "Curses" do
    url "https://cpan.metacpan.org/authors/id/G/GI/GIRAFFED/Curses-1.37.tar.gz"
    sha256 "74707ae3ad19b35bbefda2b1d6bd31f57b40cdac8ab872171c8714c88954db20"
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
        system "make"
        system "make", "install"
      end
    end

    # Disable dynamic selection of perl which may cause segfault when an
    # incompatible perl is picked up.
    # https://github.com/Homebrew/homebrew-core/issues/4936
    rewrite_shebang detected_perl_shebang, "asciiquarium"

    chmod 0755, "asciiquarium"
    bin.install "asciiquarium"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    on_linux do
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

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
      sleep 1
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
