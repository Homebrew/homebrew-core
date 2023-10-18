class Gmssl < Formula
  desc "Toolkit for Chinese national cryptographic standards"
  homepage "https://github.com/guanzhi/GmSSL"
  url "https://github.com/guanzhi/GmSSL/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "a3cdf5df87b07df33cb9e30c35de658fd0c06d5909d4428f4abd181d02567cde"
  license "Apache-2.0"
  head "https://github.com/guanzhi/GmSSL.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0642b033fb10cbdc78325dfdfac602a85f07801c2d76331578a84be62e917913"
    sha256 cellar: :any,                 arm64_ventura:  "3901189ad99d6383777117a33b8cac4cbdcb96874dd7df8c620b305aa4c05f16"
    sha256 cellar: :any,                 arm64_monterey: "0adabc2e2e7d41fff55c5ac4a24676001a2df3b59f71e0ffb22da34997206c1d"
    sha256 cellar: :any,                 arm64_big_sur:  "637d92fb7828aa336a56bd87e97a4a12944fa115b4b1d36f918cc919313df60d"
    sha256 cellar: :any,                 sonoma:         "3fe3de850f878baa72987eb4f0ab4a64375d23cbc941fa363960c39d82315094"
    sha256 cellar: :any,                 ventura:        "0ac11a28a67f0b54e914a0077c663546d5487e24543ee344a5c8f53b2e2b4736"
    sha256 cellar: :any,                 monterey:       "334078972e49393d539b5ed1a376835cac1e83188871ad7583ce530a3aab4062"
    sha256 cellar: :any,                 big_sur:        "50bb11e538f4f5e59c7d89f7543cddb744d81aa780ec5887e8585070958f2a33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "118622ab1fe804ebe6207c89e52aa460fca02994ca3127913fe4563cc8a8ff44"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    expected_output = "ba7cc1a5be11d5f00dc8a88a9fedd74ccc9faf4655da08b7be3ae7e3954c76f1"
    output = pipe_output("#{bin}/gmssl sm3", "This is a test file").chomp
    assert_equal expected_output, output
  end
end
