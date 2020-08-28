class Cpio < Formula
  desc "Copies files into or out of a cpio or tar archive"
  homepage "https://www.gnu.org/software/cpio/"
  url "https://ftp.gnu.org/gnu/cpio/cpio-2.13.tar.bz2"
  mirror "https://ftpmirror.gnu.org/cpio/cpio-2.13.tar.bz2"
  sha256 "eab5bdc5ae1df285c59f2a4f140a98fc33678a0bf61bdba67d9436ae26b46f6d"
  revision 2

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1e2e8f240d9455593a653d4cc0759ee1a0596fe88641ad6a79d652f6596bb21b" => :catalina
    sha256 "566b73ec056c1441e84e5be4d8f22ae0e9eec609e340d56d9ba22ebefaa273c6" => :mojave
    sha256 "35cc00b8c97558822cc49cca1f40ba7a3a65af06be17317721ff471414c6f430" => :high_sierra
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
