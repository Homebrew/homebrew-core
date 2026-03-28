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

  # Fix washed-out/gray colors on terminals that customise their ANSI palette
  # (e.g. many iTerm2 profiles desaturate colors 0-7 for readability).
  # Term::Animation initialises Curses color pairs 1-8 from the terminal's
  # ANSI palette colors 0-7. Re-initialising those pairs with xterm-256color
  # slots 16-231 (standard RGB values, not overridable per profile) restores
  # vivid colors. use_default_colors() + bg=-1 keeps character backgrounds
  # transparent, matching the terminal background instead of forcing black.
  patch :DATA

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    # Fix two Term::Animation bugs that cause gray/washed-out colors on modern ncurses:
    # 1. bkgdset() with a COLOR_PAIR is OR'd into every drawn character's attributes,
    #    corrupting color pairs (e.g. COLOR_BLACK → uninitialised pair → terminal
    #    default color, turning the castle and submarine gray).
    # 2. Missing attrset(0) before the per-frame space-fill lets color attributes
    #    from the previous frame bleed into the background.
    inreplace libexec/"lib/perl5/Term/Animation.pm" do |s|
      s.gsub! "$self->{WIN}->bkgdset($self->{COLORS}{'w'});",
              "$self->{WIN}->bkgdset(0);"
      s.sub!  "\t\t$self->{WIN}->addstr( 0, 0, ' 'x$self->size() );",
              "\t\t$self->{WIN}->attrset(0);\n\t\t$self->{WIN}->addstr( 0, 0, ' 'x$self->size() );"
    end

    chmod 0755, "asciiquarium"
    bin.install "asciiquarium"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
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

__END__
--- a/asciiquarium
+++ b/asciiquarium
@@ -87,6 +87,22 @@
 	#nodelay(1);

 	$anim->color(1);
+
+	# Override Curses color pairs with fixed xterm-256color palette entries.
+	# Slots 16-231 have standard RGB values independent of terminal profile,
+	# so colors stay vivid even when the ANSI palette (0-7) is customised.
+	# use_default_colors() + bg=-1 makes character backgrounds transparent.
+	if(COLORS() >= 232) {
+		use_default_colors();
+		init_pair(1, 231, -1);  # w = white   (#ffffff)
+		init_pair(2, 196, -1);  # r = red     (#ff0000)
+		init_pair(3,  46, -1);  # g = green   (#00ff00)
+		init_pair(4,  27, -1);  # b = blue    (#005fff)
+		init_pair(5,  51, -1);  # c = cyan    (#00ffff)
+		init_pair(6, 201, -1);  # m = magenta (#ff00ff)
+		init_pair(7, 226, -1);  # y = yellow  (#ffff00)
+		init_pair(8, 238, -1);  # k = dark    (#444444)
+	}

 	my $start_time = time;
 	my $paused = 0;
