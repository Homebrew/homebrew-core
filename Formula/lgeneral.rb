class Lgeneral < Formula
  desc "Turn-based strategy engine heavily inspired by Panzer General"
  homepage "https://lgames.sourceforge.io/LGeneral/"
  url "https://downloads.sourceforge.net/lgeneral/lgeneral/lgeneral-1.4.4.tar.gz"
  sha256 "0a26b495716cdcab63b49a294ba31649bc0abe74ce0df48276e52f4a6f323a95"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "b0881e6bd6b537c4dc322711a44d7567e6a2b624516d53d11d6524da5d35da79"
    sha256 arm64_big_sur:  "39fd0efe18280a2e4b976ebf02f451c110de2a5222735e4d8d6ede97c22b28da"
    sha256 monterey:       "a8b456e9aaeb0e99e8866d9f58a6f228688b770ab4962a124c17fbedab620d74"
    sha256 big_sur:        "4e1eadd9caf43f4c37ae2a5046e124e08b815faf3e81032a7d82ca42313cc737"
    sha256 catalina:       "66d10dfacdb72700cec8fafd0e86e79ff0e63380b75df3b41f46c6bd3b6ccdc9"
    sha256 x86_64_linux:   "b56e6479e47df76fbda4e241872269c9ba9ea59170153aca6b5adbaaf69cec84"
  end

  depends_on "gettext"
  depends_on "sdl12-compat"
  depends_on "sdl2"

  def install
    # Applied in community , to remove in next release
    inreplace "configure", "#include <unistd.h>", "#include <sys/stat.h>\n#include <unistd.h>"
    system "./configure", *std_configure_args,
                         "--disable-silent-rules",
                         "--disable-sdltest"
    system "make", "install"
  end

  def post_install
    %w[nations scenarios units sounds maps gfx].each { |dir| (pkgshare/dir).mkpath }
    %w[flags units terrain].each { |dir| (pkgshare/"gfx"/dir).mkpath }
  end

  def caveats
    <<~EOS
      Requires pg-data.tar.gz or the original DOS version of Panzer General. Can be downloaded from
      https://sourceforge.net/projects/lgeneral/files/lgeneral-data/pg-data.tar.gz/download
      To install use:
        lgc-pg -s <pg-data-unziped-dir> -d #{opt_pkgshare}
    EOS
  end

  test do
    system bin/"lgeneral", "--version"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    pid = fork do
      exec bin/"lgeneral"
    end
    sleep 3
    Process.kill "TERM", pid
  end
end
