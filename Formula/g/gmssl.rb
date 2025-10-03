class Gmssl < Formula
  desc "Toolkit for Chinese national cryptographic standards"
  homepage "https://github.com/guanzhi/GmSSL"
  url "https://github.com/guanzhi/GmSSL/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "23ed2ce74e408fc4c80289d2b499c7c5eec8373fefaf3827a53cb4c134dd5263"
  license "Apache-2.0"
  head "https://github.com/guanzhi/GmSSL.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "266ec2801df7d7db32a65e5e339e69bafd1af122d0463d8e4d2664db7a29d63a"
    sha256 cellar: :any,                 arm64_sequoia:  "352a3e4a2a51ef7a60363f8c2edc6d780132b8b24cef552449c5e3ec0e0c7184"
    sha256 cellar: :any,                 arm64_sonoma:   "33e55c6a9023a0e8a7868b466131f94078ad80547ce2ce5d97b64d1a5df4890b"
    sha256 cellar: :any,                 arm64_ventura:  "9114f6d41defc40bb2b10fc627f22090485a7f6094d27cf872c7166078eae3fd"
    sha256 cellar: :any,                 arm64_monterey: "ec6a86111951bfcf6072e771e7ee82880aefe5d9dae3d58ed229cc3064e6a0fa"
    sha256 cellar: :any,                 sonoma:         "7455eb22baeafa0ad277b44ba5a04f60fdbfc87e9140562bdf6231b747c17083"
    sha256 cellar: :any,                 ventura:        "ab4cced1064fee652a7f88d0fd34d2658ed53e0bd657ec1cf82905651a4c4977"
    sha256 cellar: :any,                 monterey:       "748de4b6cfb67d0e170f69355f6ab82bfb3709fc2e744b48bb173f66a11fdb29"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "518ec7266886c426bcd7d409d53bf012d681efd2701a4454ce29082547a8ab9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "623f545c3d4d999cba1a76c2ac9960008aefa519965b1b86b431505617eee727"
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
