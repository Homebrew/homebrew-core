class Lsof < Formula
  desc "Utility to list open files"
  homepage "https://people.freebsd.org/~abe/"
  url "https://www.mirrorservice.org/sites/lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_4.91.tar.bz2"
  sha256 "c9da946a525fbf82ff80090b6d1879c38df090556f3fe0e6d782cb44172450a3"

  bottle do
    cellar :any_skip_relocation
    sha256 "830be0b158cbb5ff2f6bf019a517e6c89ff013760a6297fe8e285e66322b8e1a" => :mojave
    sha256 "276399b5b42f5a9dc167515add55c3bb2e545faec1299516b06793b1581a9311" => :high_sierra
    sha256 "9d57eea962770c2f3c5b56d26d9fdb9b0bbdde559dfc92d0c9db3dcaae33cc43" => :sierra
    sha256 "59c8c1a9455e3f10c8d6326bab49ab33a85c3cfa702627aa4ba2dd9600cc7d72" => :el_capitan
  end

  def install
    system "tar", "xf", "lsof_#{version}_src.tar"
    cd "lsof_#{version}_src" do
      inreplace "dialects/darwin/libproc/dfile.c",
                "#extern\tstruct pff_tab\tPgf_tab[];", "extern\tstruct pff_tab\tPgf_tab[];"

      ENV["LSOF_INCLUDE"] = "#{MacOS.sdk_path}/usr/include"

      # Source hardcodes full header paths at /usr/include
      inreplace %w[
        dialects/darwin/kmem/dlsof.h
        dialects/darwin/kmem/machine.h
        dialects/darwin/libproc/machine.h
      ], "/usr/include", "#{MacOS.sdk_path}/usr/include"

      mv "00README", "README"
      system "./Configure", "-n", "darwin"
      system "make"
      bin.install "lsof"
      man8.install "lsof.8"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"test").open("w") do
      system "#{bin}/lsof", testpath/"test"
    end
  end
end
