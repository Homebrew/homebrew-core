class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "https://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/refs/tags/libcec-6.0.2.tar.gz"
  sha256 "090696d7a4fb772d7acebbb06f91ab92e025531c7c91824046b9e4e71ecb3377"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "04b0eba59ea6e85ed61dbd833df3097ca8fea728bc736794a30f515b5c1180e6"
    sha256 cellar: :any,                 arm64_sonoma:   "4ae97897b594a5f39f8e87beec34fe49aa3c6d9e9ba78c0a98b856b039ddfe89"
    sha256 cellar: :any,                 arm64_ventura:  "c7aff3833ac339327e1881340d289cae6864dddca9ed4237d50c401856a9bf56"
    sha256 cellar: :any,                 arm64_monterey: "b888e7cd72aaa5312697203f0146f4352e42439fc625c4e6798ef90e930c3402"
    sha256 cellar: :any,                 arm64_big_sur:  "d3c6c1ef0af67ec3bcc8d2357e2c3a937b79cc8298e2a09f462870a0b0efed8a"
    sha256 cellar: :any,                 sonoma:         "492cbb0d6581b40dac0143977f98bbb2392f487ddb257696648bfab7ada90177"
    sha256 cellar: :any,                 ventura:        "1cfe634b03237f5e68cc4c3586c73fd5f22c7ab16a4e21bda0ab71c66673c9aa"
    sha256 cellar: :any,                 monterey:       "763e6237d21c4a4b637256e192c17676b7f2466b66ce446a2f22732497e66558"
    sha256 cellar: :any,                 big_sur:        "8dfef5759341d551a996bbcedcbef9a8876e12c046dd3d4b40bbc4c72bbaa9a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a26708626f2907713d38286ccb552b68514c44bc08e21761db8736db19b6956c"
  end

  depends_on "cmake" => :build

  uses_from_macos "ncurses"

  resource "p8-platform" do
    url "https://github.com/Pulse-Eight/platform/archive/refs/tags/p8-platform-2.1.0.1.tar.gz"
    sha256 "064f8d2c358895c7e0bea9ae956f8d46f3f057772cb97f2743a11d478a0f68a0"
  end

  def install
    ENV.cxx11

    # The CMake scripts don't work well with some common LIBDIR values:
    # - `CMAKE_INSTALL_LIBDIR=lib` is interpreted as path relative to build dir
    # - `CMAKE_INSTALL_LIBDIR=#{lib}` breaks pkg-config and cmake config files
    # - Setting no value uses UseMultiArch.cmake to set platform-specific paths
    # To avoid these issues, we can specify the type of input as STRING
    cmake_args = std_cmake_args.map do |s|
      s.gsub "-DCMAKE_INSTALL_LIBDIR=", "-DCMAKE_INSTALL_LIBDIR:STRING="
    end

    resource("p8-platform").stage do
      system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "libCEC version: #{version}", shell_output("#{bin}/cec-client --info")
  end
end
