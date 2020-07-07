class Cpio < Formula
  desc "Copies files into or out of a cpio or tar archive"
  homepage "https://www.gnu.org/software/cpio/"
  url "https://ftp.gnu.org/gnu/cpio/cpio-2.13.tar.bz2"
  mirror "https://ftpmirror.gnu.org/cpio/cpio-2.13.tar.bz2"
  sha256 "eab5bdc5ae1df285c59f2a4f140a98fc33678a0bf61bdba67d9436ae26b46f6d"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "9d35514dcf0a28d40c8be8517ef67ebc5b503d77d31d0bb600ab380653f45806" => :catalina
    sha256 "ae7a8a7d04dcd42e8da62e076153fc9aab0ec736c6607578a09aa716cf08c3e1" => :mojave
    sha256 "11b5aff617eb9113a92e5eed3ba783d418e5af64d93f04b96536fa48aeb7f090" => :high_sierra
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
