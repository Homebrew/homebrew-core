class Lgeneral < Formula
  desc "Turn-based strategy engine heavily inspired by Panzer General"
  homepage "https://lgames.sourceforge.io/LGeneral/"
  url "https://downloads.sourceforge.net/lgeneral/lgeneral/lgeneral-1.4.4.tar.gz"
  sha256 "0a26b495716cdcab63b49a294ba31649bc0abe74ce0df48276e52f4a6f323a95"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 arm64_tahoe:   "a65fba44b56f1ae92c209b5542e45371b8566fd465a8eb1c39913a4bdf334793"
    sha256 arm64_sequoia: "ff23d123436ef67a86f2b93d07eac7fd03288ccd96745e32f571638cf0b69a22"
    sha256 arm64_sonoma:  "fea145ba99b260a67c2435e7c2841df67cc8cd95ea292d97de29dae08b7fe5d4"
    sha256 sonoma:        "1c8ea19f1051169fc4f4cc6cc8d8b64111fea88e7c149fce7de18178b1747670"
    sha256 arm64_linux:   "b9b4ccb1fd4edcea2fcd56e5a167ec41a5f3ef8dd8ca175f46508493ae251d9f"
    sha256 x86_64_linux:  "feadf3058a4c903237b6cf8d09b61f97ba5fb5656a6ff3819f96660dd0d4400b"
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

    # Preserve all empty directories which are needed at runtime
    touch pkgshare.find.filter_map { |path| path/".keepme" if path.directory? && path.children.empty? }
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
