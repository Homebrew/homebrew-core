class Dtc < Formula
  desc "Device tree compiler"
  homepage "https://www.devicetree.org/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/device-tree-compiler/device-tree-compiler_1.4.2.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/d/device-tree-compiler/device-tree-compiler_1.4.2.orig.tar.gz"
  sha256 "219b4b062ecbd7b0693351d69c09d883dd3f00588275fe2e3d603fd36b60ee16"

  bottle do
    cellar :any
    sha256 "e51ec039535cdc04002bfe0b0d9a0fba95a842fb24d6f7a7478f91627efdcad1" => :sierra
    sha256 "21b2a94495d4ee45566ad89c92e8f1be054a6ef9be16db08c47efabfd90818c0" => :el_capitan
    sha256 "43b895242bb617aabdf2b7c4e019af4115fdca865d980d61f09ab5f0806a8d1a" => :yosemite
  end

  def install
    system "make"
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
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
