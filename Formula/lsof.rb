class LsofDownloadStrategy < CurlDownloadStrategy
  def stage
    super
    safe_system "/usr/bin/tar", "xf", "#{name}_#{version}_src.tar"
    cd "#{name}_#{version}_src"
  end
end

class Lsof < Formula
  desc "Utility to list open files"
  homepage "https://people.freebsd.org/~abe/"
  url "https://mirrorservice.org/sites/lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_4.89.tar.bz2",
    :using => LsofDownloadStrategy
  sha256 "81ac2fc5fdc944793baf41a14002b6deb5a29096b387744e28f8c30a360a3718"

  bottle do
    cellar :any_skip_relocation
    sha256 "2312dceb501fa6d9301fa506370784456937404ac43381354457ce63d99ccd56" => :sierra
    sha256 "fb14a3aef899327098b92d6d2c283e8978fc34d55b42019b8a54338abe8d4853" => :el_capitan
    sha256 "8a63b65f74b992e4a70ac3e18a7e4b810a73e183b13086b40f30286256e646e0" => :yosemite
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/c3acbb8/lsof/lsof-489-darwin-compile-fix.patch"
    sha256 "997d8c147070987350fc12078ce83cd6e9e159f757944879d7e4da374c030755"
  end

  def install
    ENV["LSOF_INCLUDE"] = "#{MacOS.sdk_path}/usr/include"

    # Source hardcodes full header paths at /usr/include
    inreplace %w[
      dialects/darwin/kmem/dlsof.h
      dialects/darwin/kmem/machine.h
      dialects/darwin/libproc/machine.h
    ], "/usr/include", "#{MacOS.sdk_path}/usr/include"

    mv "00README", "README"
    system "./Configure", "-n", `uname -s`.chomp.downcase
    system "make"
    bin.install "lsof"
    man8.install "lsof.8"
  end

  test do
    (testpath/"test").open("w") do
      system "#{bin}/lsof", testpath/"test"
    end
  end
end
