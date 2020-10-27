class ChibiScheme < Formula
  desc "Small footprint Scheme for use as a C Extension Language"
  homepage "https://github.com/ashinn/chibi-scheme"
  url "https://github.com/ashinn/chibi-scheme/archive/0.9.1.tar.gz"
  sha256 "a9ee2afd7671418bc09a4d386448dbfd0662421ea1eb1c5ed3b68c071307854d"
  license "BSD-3-Clause"
  head "https://github.com/ashinn/chibi-scheme.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "75122fe5413f7f206e9fcc717307d3603041a39a93b895c4b89a02845ac4c683" => :catalina
    sha256 "0ce202e52817dbed3e87e5911a74ad7f85e6f081b45deba0427d5d09b1dcb6ae" => :mojave
    sha256 "c3dac9e5642a0d725ae1d77e0a9139e829b24c7c34e8e85eb58e506d7ba2e240" => :high_sierra
  end

  def install
    ENV.deparallelize

    # "make" and "make install" must be done separately
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = `#{bin}/chibi-scheme -mchibi -e "(for-each write '(0 1 2 3 4 5 6 7 8 9))"`
    assert_equal "0123456789", output
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
