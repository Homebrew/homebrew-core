class Precomp < Formula
  desc "Command-line precompressor to achieve better compression"
  homepage "http://schnaader.info/precomp.php"
  url "https://github.com/schnaader/precomp-cpp/archive/v0.4.7.tar.gz"
  sha256 "b4064f9a18b9885e574c274f93d73d8a4e7f2bbd9e959beaa773f2e61292fb2b"
  head "https://github.com/schnaader/precomp-cpp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "007ecd8dbf6db55a52ca49765d1aafd9e4f72c6a6f377e8eec8b28641fd486ed" => :mojave
    sha256 "83f6d3eec9ce5b05a5cc7197e89fc6fe968c7ecb71c795343ead7ec98edcf758" => :high_sierra
    sha256 "93eaa1f454f3af8d1c9872c263e3e67b56aac5e6772a65ccce8c9ec493c6989c" => :sierra
    sha256 "62c8a72958b6fa8ef0208560ff0ad6abf187aae842715bb84cddb21d46a69d35" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    bin.install "precomp"
  end

  test do
    cp "#{bin}/precomp", testpath/"precomp"
    system "gzip", "-1", testpath/"precomp"

    system "#{bin}/precomp", testpath/"precomp.gz"
    rm testpath/"precomp.gz", :force => true
    system "#{bin}/precomp", "-r", testpath/"precomp.pcf"
    system "gzip", "-d", testpath/"precomp.gz"
  end
end
