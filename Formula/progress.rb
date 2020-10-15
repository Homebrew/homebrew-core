class Progress < Formula
  desc "Coreutils progress viewer"
  homepage "https://github.com/Xfennec/progress"
  url "https://github.com/Xfennec/progress/archive/v0.15.tar.gz"
  sha256 "1ed0ac65a912ef1aa605d524eaddaacae92079cf71182096a7c65cbc61687d1b"
  license "GPL-3.0"
  head "https://github.com/Xfennec/progress.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "104d62681c513b6c3e7d997245768d7e2e3941ab43dc37fb67b33bb188e4acc4" => :catalina
    sha256 "62ea2e563eac2c9c9ad6f8eb3d5565024b2e303313c6d5cf509901893ee01d32" => :mojave
    sha256 "699d0712e633d357dbd853e797e94f85bee3af00f70b9e206fe6335d620b8e5c" => :high_sierra
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    pid = fork do
      system "/bin/dd", "if=/dev/urandom", "of=foo", "bs=512", "count=1048576"
    end
    sleep 1
    begin
      assert_match "dd", shell_output("#{bin}/progress")
    ensure
      Process.kill 9, pid
      Process.wait pid
      rm "foo"
    end
  end
end
