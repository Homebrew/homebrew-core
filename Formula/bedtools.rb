class Bedtools < Formula
  desc "Tools for genome arithmetic (set theory on the genome)"
  homepage "https://github.com/arq5x/bedtools2"
  url "https://github.com/arq5x/bedtools2/archive/v2.29.1.tar.gz"
  sha256 "504c0992caa027ec1840ea9ca6909f7e59e7ebc1a2b422233b35abb9592aff5c"

  bottle do
    cellar :any
    sha256 "d511d1636d496882cbc1ac78089f08d549329a6226b0b7cfc31812b72d3dff17" => :catalina
    sha256 "c0279bb1c7687541472e1bba4a171ce411a0fafab538dcb3c72be426f7bb0adb" => :mojave
    sha256 "dd16efe379fb9774292621a47fa26b9281b524a9c5bdc6adcf0d753452259fd4" => :high_sierra
  end

  depends_on "xz"

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"t.bed").write "c\t1\t5\nc\t4\t9"
    assert_equal "c\t1\t9", shell_output("#{bin}/bedtools merge -i t.bed").chomp
  end
end
