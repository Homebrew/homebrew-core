class Lgeneral < Formula
  desc "Turn-based strategy engine heavily inspired by Panzer General"
  homepage "https://lgames.sourceforge.io/LGeneral/"
  url "https://downloads.sourceforge.net/lgeneral/lgeneral/lgeneral-1.4.4.tar.gz"
  sha256 "0a26b495716cdcab63b49a294ba31649bc0abe74ce0df48276e52f4a6f323a95"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "d9c193de410ea328ab981c20bf225559f72b56eb10c9976c115f161766ba7556"
    sha256 arm64_sonoma:   "25fd2eb3ec6f1bf56aeedda2833e0b934b167b0532afd1b832f568018bd5249f"
    sha256 arm64_ventura:  "6814c4921c62261436537a16b3d945863fd8afa2e3f9702e1fe2b15d98ce9cc4"
    sha256 arm64_monterey: "66e1e176e9fe55234aac274f8aab642aefaf71c8257576ef693eff1b21867f62"
    sha256 arm64_big_sur:  "262a595324361728d033438f3373024b1925557ed9e1d19f7a921aae9370eeb9"
    sha256 sonoma:         "89c8dda7ff7215ceb65ae56a8c9d65734f9b005265c5ddc0ff0f4debd4d361c3"
    sha256 ventura:        "237418ae7e4069b558b046d4b68044c3c307c28898ff00ca56a20aa97d13d542"
    sha256 monterey:       "bc51bd29569a83218f84748d31bac40cadff60a7caacaead3e499970aba25b37"
    sha256 big_sur:        "643779c73ca7a36a3db58993aa374f451bfb3e4c50bd699968137e77330acddf"
    sha256 x86_64_linux:   "eefab1384276b2406cbdb286bfc730b3d434112f2d5ea8be6c3edb451d34f2e9"
  end

  depends_on "gettext"
  depends_on "sdl12-compat"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

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
        lgc-pg -s <pg-data-unzipped-dir> -d #{opt_pkgshare}
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
