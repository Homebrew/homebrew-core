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
    sha256 "7a1af5022ec08f89fb8b2dc40c176e38a90f6ccd7a0dc3a789738a0a27a60c14" => :el_capitan
    sha256 "e0500f7de8b92f559375223e0064b17f0b7e5d7f1c7c955e08982e9eb12cafa0" => :yosemite
    sha256 "52ca808a856bd9813a915da3f52522b8be7df08a3a9c91157143627fa0051c77" => :mavericks
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
