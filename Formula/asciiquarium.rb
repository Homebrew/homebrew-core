require "language/perl"

class Asciiquarium < Formula
  include Language::Perl::Shebang

  desc "Aquarium animation in ASCII art"
  homepage "https://robobunny.com/projects/asciiquarium/html/"
  url "https://robobunny.com/projects/asciiquarium/asciiquarium_1.1.tar.gz"
  sha256 "1b08c6613525e75e87546f4e8984ab3b33f1e922080268c749f1777d56c9d361"
  license "GPL-2.0-or-later"
  revision 4

  livecheck do
    url "https://robobunny.com/projects/asciiquarium/"
    regex(/href=.*?asciiquarium[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "eaeef5f718e5346acce2ce6680d3970a3d8e7e7f6ee0ea0a4a58ca0e4b2d0c60"
    sha256 cellar: :any,                 arm64_monterey: "bffaf8931358ce91194a050df4d70785d1675ae86a13abf16039a6633961e59c"
    sha256 cellar: :any,                 arm64_big_sur:  "054f9401007de6e17d4ed642bb4c38490fcbf72713e6357b0269ee0f3e538e36"
    sha256 cellar: :any,                 ventura:        "4d723f7505af54bf515aa127a673d5a700e1f04573214826b43f7fb323c7c816"
    sha256 cellar: :any,                 monterey:       "6dd99c8969cd14a6ab694d9fc3df4ce29bd6b262aefc04af71714e26e081577b"
    sha256 cellar: :any,                 big_sur:        "3328f27bbb4cecfb62236e12fcac7f0f101c21d3843533d9d687f1d8892ebe73"
    sha256 cellar: :any,                 catalina:       "20b7a67f26033299553cbcc66e01f75510ee16f384d670a92546c282349865b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c6e8ffdf5b6f3578234c833129b28cdefe9055980c391ca069aa9d69c85f7dd"
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
