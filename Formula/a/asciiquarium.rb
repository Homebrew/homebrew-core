require "language/perl"

class Asciiquarium < Formula
  include Language::Perl::Shebang

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

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0c6038b3b3d941069ce1d329a6641d29ef3e2d84ca391809836ae9c527f55478"
    sha256 cellar: :any,                 arm64_ventura:  "b8062a7862f2dbc72be6734d7ea25b06e3acad719d8c44bed08059be02ae71d8"
    sha256 cellar: :any,                 arm64_monterey: "e197deaee9423e203938370adb0c252c92372b1e7e196a6b33477c2c1cc29ccf"
    sha256 cellar: :any,                 sonoma:         "081c78955c7ed4975d4bc660153b306675f3517a661f84c79f25fe823bfda7b3"
    sha256 cellar: :any,                 ventura:        "e7cae33ae78d065af614e683c8d43e50053609a53936d5fb91af9a80b2daa87d"
    sha256 cellar: :any,                 monterey:       "49a2c910973ea1e73abb2f350f3c2bbb932a009790c78b41f87538195bd59546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32a89a8d26c5fa6243a92d0b1bce5a8be721da358c461c6a4a9f2f932bc4274b"
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
