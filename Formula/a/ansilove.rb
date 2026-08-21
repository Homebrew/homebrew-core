class Ansilove < Formula
  desc "ANSI/ASCII art to PNG converter"
  homepage "https://www.ansilove.org"
  url "https://github.com/ansilove/ansilove/releases/download/4.2.2/ansilove-4.2.2.tar.gz"
  sha256 "443e1d8b6d94851cb9563f530b56fb5ef8ffba4b1eda6fd2c3cafaa38adb62d3"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3eec3245f0c8b602e2a9702a06979cc7bf60bec756d3f47884df774bee8f5175"
    sha256 cellar: :any, arm64_sequoia: "24156f04a731bbbbbaee45cdf4aadbd56f60044c80c9330f324f8221e04e9b86"
    sha256 cellar: :any, arm64_sonoma:  "1a6b11e09545aeedeaf11ddcdf4ffe1b27ba9408a357bc8ab909c5af23a74ebb"
    sha256 cellar: :any, sonoma:        "87450d7c0fbef066b3ce65011a35c7ff9c62aadd6eed75bdac2bb9b845b2d312"
    sha256 cellar: :any, arm64_linux:   "57374df00531d3d4bc1394afe9293185ec43c7a3d8e683b027fb53bbc299b49a"
    sha256 cellar: :any, x86_64_linux:  "7d888f27956b0f9f05866e78497df6de6fcc8f2f0a55ba03cfb1503def8500b2"
  end

  depends_on "cmake" => :build
  depends_on "libansilove"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/burps/bs-ansilove.ans" => "test.ans"
  end

  test do
    output = shell_output("#{bin}/ansilove -o #{testpath}/output.png #{pkgshare}/test.ans")
    assert_match "Font: 80x25", output
    assert_match "Id: SAUCE v00", output
    assert_match "Tinfos: IBM VGA", output
    assert_path_exists testpath/"output.png"
  end
end
