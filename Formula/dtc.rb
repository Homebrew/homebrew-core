class Dtc < Formula
  desc "Device tree compiler"
  homepage "https://www.devicetree.org/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/device-tree-compiler/device-tree-compiler_1.4.5.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/d/device-tree-compiler/device-tree-compiler_1.4.5.orig.tar.gz"
  sha256 "d13df67f5402c1905d2c24603471fe783965112ab5004025a50f7f852cd89bc8"

  bottle do
    cellar :any
    sha256 "85ede678c4e04e074e8aaf9e1331d2fd4235297cc92747be2362f7fe5604987b" => :high_sierra
    sha256 "71aaae19cc7f53e650bc807844135b8a2527084dc153fcaaaab0d7a552e6caa4" => :sierra
    sha256 "5affa8e37eff06e88eb1f571fbfb0dcef60cf7b1efebdc72b511c435c1509b8f" => :el_capitan
  end

  def install
    system "make", "NO_PYTHON=1"
    system "make", "NO_PYTHON=1", "DESTDIR=#{prefix}", "PREFIX=", "install"
    mv lib/"libfdt.dylib.1", lib/"libfdt.1.dylib"
  end

  test do
    (testpath/"test.dts").write <<-EOS.undent
      /dts-v1/;
      / {
      };
    EOS
    system "#{bin}/dtc", "test.dts"
  end
end
