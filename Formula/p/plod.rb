class Plod < Formula
  desc "Keep an online journal of what you're working on"
  homepage "https://web.archive.org/web/20240510181918/https://deer-run.com/users/hal/"
  url "https://web.archive.org/web/20160821040241/https://deer-run.com/~hal/plod/plod.shar"
  version "1.9"
  sha256 "1b7b8267c41b11c2f5413a8d6850099e0547b7506031b0c733121ed5e8d182f5"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c66eae9ec8211f26b1dd03894db3be83acd71fac5b27d39a6381482bf7f22d9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b9c9cd2b570e27155488643d25109a5782ef3acbf76aa86ce249630999c5043"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8361343544ac10cdf1c2c6b37b4a8a4882d199c2d49ac22fc35b776199527fbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8361343544ac10cdf1c2c6b37b4a8a4882d199c2d49ac22fc35b776199527fbf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8361343544ac10cdf1c2c6b37b4a8a4882d199c2d49ac22fc35b776199527fbf"
    sha256 cellar: :any_skip_relocation, sonoma:         "50b1de5ad6d7fd6c74d36d14f45ea812fd606b1d1c1c3779c071c7c957323d48"
    sha256 cellar: :any_skip_relocation, ventura:        "7398f28822ffb0a9b2d84ba2bf98ed4bb49dea0c26ed4d8b6b0c16360173ca4b"
    sha256 cellar: :any_skip_relocation, monterey:       "7398f28822ffb0a9b2d84ba2bf98ed4bb49dea0c26ed4d8b6b0c16360173ca4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7398f28822ffb0a9b2d84ba2bf98ed4bb49dea0c26ed4d8b6b0c16360173ca4b"
    sha256 cellar: :any_skip_relocation, catalina:       "7398f28822ffb0a9b2d84ba2bf98ed4bb49dea0c26ed4d8b6b0c16360173ca4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "427039e1e718a334f7d4a2e803de0567e33d38908ea56204f3bb6476709d82ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8361343544ac10cdf1c2c6b37b4a8a4882d199c2d49ac22fc35b776199527fbf"
  end

  # Upstream site shows error 503. As of deprecation date,
  # install-on-request: 0 (30 days), 1 (90 days), 12 (365 days)
  deprecate! date: "2024-09-14", because: :unmaintained
  disable! date: "2025-09-14", because: :unmaintained

  def install
    system "sh", "plod.shar"

    pager = ENV["PAGER"] || "/usr/bin/less"
    editor = ENV["EDITOR"] || "/usr/bin/emacs"
    visual = ENV["VISUAL"] || editor

    inreplace "plod" do |s|
      s.gsub! "#!/usr/local/bin/perl", "#!/usr/bin/env perl"
      s.gsub! '"/bin/crypt"', "undef"
      s.gsub! "/usr/local/bin/less", pager
      s.gsub! '$EDITOR = "/usr/local/bin/emacs"', "$EDITOR = \"#{editor}\""
      s.gsub! '$VISUAL = "/usr/local/bin/emacs"', "$VISUAL = \"#{visual}\""
    end
    man1.install "plod.man" => "plod.1"
    bin.install "plod"
    prefix.install "plod.el.v1", "plod.el.v2"

    (prefix/"plodrc").write <<~EOS
      # Uncomment lines and change their values to override defaults.
      # man plod for further details.
      #
      # $PROMPT = 0;
      # $CRYPTCMD = undef;
      # $TMPFILE = "/tmp/plodtmp$$";
      # $HOME = (getpwuid($<))[7];
      # $EDITOR = "#{editor}";
      # $VISUAL = "#{visual}";
      # $PAGER =  "#{pager}";
      # $LINES = 24;
      # $LOGDIR = "$HOME/.logdir";
      # $LOGFILE = sprintf("%04d%02d", $YY+1900, $MM);
      # $BACKUP = ".plod$$.bak";
      # $DEADLOG = "dead.log";
      # $STAMP = sprintf("%02d/%02d/%04d, %02d:%02d --", $MM, $DD, $YY+1900, $hh, $mm);
      # $PREFIX = '';
      # $SUFFIX = '';
      # $SEPARATOR = '-----';
    EOS
  end

  def caveats
    <<~EOS
      Emacs users may want to peruse the two available plod modes. They've been
      installed at:

        #{prefix}/plod.el.v1
        #{prefix}/plod.el.v2

      Certain environment variables can be customized.

        cp #{prefix}/plodrc ~/.plodrc

      See man page for details.
    EOS
  end

  test do
    ENV["LOGDIR"] = testpath/".logdir"
    system bin/"plod", "this", "is", "Homebrew"
    assert File.directory? "#{testpath}/.logdir"
    assert_match(/this is Homebrew/, shell_output("#{bin}/plod -P"))
  end
end
