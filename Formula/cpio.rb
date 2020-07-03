class Cpio < Formula
  desc "Copies files into or out of a cpio or tar archive"
  homepage "https://www.gnu.org/software/cpio/"
  url "https://ftp.gnu.org/gnu/cpio/cpio-2.13.tar.bz2"
  mirror "https://ftpmirror.gnu.org/cpio/cpio-2.13.tar.bz2"
  sha256 "eab5bdc5ae1df285c59f2a4f140a98fc33678a0bf61bdba67d9436ae26b46f6d"

  bottle do
    cellar :any_skip_relocation
    sha256 "7648c6e9a9cc7c7834674ec839f8811134a109e9419fefc165107e1489fffefb" => :catalina
    sha256 "d8e90cbadcf1856c4c3291ba0d2798984a8c6069464d87be92ef3b9db622118e" => :mojave
    sha256 "cfd09e4738ac54a935262baf38b546770942e90b6327c3b5342d2604aa37e733" => :high_sierra
  end

  keg_only :shadowed_by_macos, "macOS provides cpio"

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <string>
    EOS
    system "ls #{testpath} | #{bin}/cpio -ov > #{testpath}/directory.cpio"
    assert_path_exist "#{testpath}/directory.cpio"
  end
end
