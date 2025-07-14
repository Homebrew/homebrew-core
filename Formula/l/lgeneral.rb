class Lgeneral < Formula
  desc "Turn-based strategy engine heavily inspired by Panzer General"
  homepage "https://lgames.sourceforge.io/LGeneral/"
  url "https://downloads.sourceforge.net/lgeneral/lgeneral/lgeneral-1.4.4.tar.gz"
  sha256 "0a26b495716cdcab63b49a294ba31649bc0abe74ce0df48276e52f4a6f323a95"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_sequoia: "0b33e1f556a20a71c72b472bbfa2fdd9461253d584cb97e47a9eb8173c376ea5"
    sha256 arm64_sonoma:  "0c3cbf2cd89161d1af99f75d4d33091f7732cc458861977f4a91eb96af230154"
    sha256 arm64_ventura: "f256bf5c22611e15d3322bc501e1d877a4b2f8c1a471fe298399a255fc44490b"
    sha256 sonoma:        "a5f8cf09603365a6a8187b3d296d7dcba9ee1fb44993f5ef81285c145ef36995"
    sha256 ventura:       "7f2a5e68361f78343b88f04dae2b0ec5a0da7be4753f8c66bdcd54e02f8bd8ea"
    sha256 arm64_linux:   "bb380cd4fea9e821acc6f40ea22fe206fae58caed0b0ca7c437e0a03fdc4b44e"
    sha256 x86_64_linux:  "7839691573fb754a1c1b7e6befc77027256bcc1908b11268474e59de60de804d"
  end

  depends_on "gettext"
  depends_on "sdl12-compat"
  depends_on "sdl2"

  def install
    # Applied in community , to remove in next release
    inreplace "configure", "#include <unistd.h>", "#include <sys/stat.h>\n#include <unistd.h>"

    args = ["--disable-silent-rules", "--disable-sdltest"]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
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
      ⚠️ Note: Sound and music are not supported in this build
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
