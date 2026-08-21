class Lgeneral < Formula
  desc "Turn-based strategy engine heavily inspired by Panzer General"
  homepage "https://lgames.sourceforge.io/LGeneral/"
  url "https://downloads.sourceforge.net/lgeneral/lgeneral/lgeneral-1.4.4.tar.gz"
  sha256 "0a26b495716cdcab63b49a294ba31649bc0abe74ce0df48276e52f4a6f323a95"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 4
    sha256 arm64_tahoe:   "cb647aa60174371e139c2b586625b198de640d9f29d26435b09ddfb73db04db9"
    sha256 arm64_sequoia: "07051ec2b86ffce75ae82c818b71752b2b868c7b4a076eb11b143f63afa67536"
    sha256 arm64_sonoma:  "280f6bc05daf76a9668906f0400f27e4a0a1b27e5d3be40bc8364f0a81abdebf"
    sha256 sonoma:        "440bf71a90bff16e1e29c78ae3df4ad0cf199e8fb14027f8cdb706cac94e5368"
    sha256 arm64_linux:   "23c00f61a0e2fd389f288ed849f4a46724160aeaf2406ae54e52677cd9032f64"
    sha256 x86_64_linux:  "25b0c6d313caff4b7ca397bcabc1712b5c98aff7f47ee1cf238f61686c39273c"
  end

  depends_on "sdl12-compat"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Applied in community , to remove in next release
    inreplace "configure", "#include <unistd.h>", "#include <sys/stat.h>\n#include <unistd.h>"

    args = ["--disable-silent-rules", "--disable-sdltest"]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm64?

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

    pid = spawn bin/"lgeneral"
    sleep 3
    Process.kill "TERM", pid
  end
end
