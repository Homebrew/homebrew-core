class Lcm < Formula
  desc "Libraries and tools for message passing and data marshalling"
  homepage "https://lcm-proj.github.io/"
  url "https://github.com/lcm-proj/lcm/releases/download/v1.4.0/lcm-1.4.0.zip"
  sha256 "e249d7be0b8da35df8931899c4a332231aedaeb43238741ae66dc9baf4c3d186"
  license "LGPL-2.1"
  revision 6
  head "https://github.com/lcm-proj/lcm.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6f663f930c725a6e01f5186aa3b73ad6f8a247673d5dca58921f3c49dc4992ab"
    sha256 cellar: :any,                 arm64_big_sur:  "a0a53217477597ebd7afe6afcb10f732831af2914ebba6434d90a543ddd09aeb"
    sha256 cellar: :any,                 monterey:       "b871f2e30a9ee82cd0830f0db5340f006d7603a15da2982f7df806a66fccddfb"
    sha256 cellar: :any,                 big_sur:        "8ae12270c1b2ba9c0c02b22a32bb96326a4694aee2e0c65e694d71ef7e1a4c05"
    sha256 cellar: :any,                 catalina:       "13a51b7c5ca3ffa82d366ae898ab98dcafa725af2a6f8319bcbf16225b0dba4f"
    sha256 cellar: :any,                 mojave:         "437bc1978078c4ad00696efb00cf4add0afa7666c1e8b7a8b6080974bed3eae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f395b8d2bc8dac7f0c332ef8a4aac62b3d9851a00c84820076addef775c29b9"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "lua"
  depends_on "openjdk"
  depends_on "python@3.9"

  def install
    args = std_cmake_args + %W[
      -DLCM_ENABLE_EXAMPLES=OFF
      -DLCM_ENABLE_TESTS=OFF
      -DLCM_JAVA_TARGET_VERSION=8
      -DPYTHON_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"example_t.lcm").write <<~EOS
      package exlcm;
      struct example_t {
          int64_t timestamp;
          double position[3];
          string name;
      }
    EOS
    system bin/"lcm-gen", "-c", "example_t.lcm"
    assert_predicate testpath/"exlcm_example_t.h", :exist?, "lcm-gen did not generate C header file"
    assert_predicate testpath/"exlcm_example_t.c", :exist?, "lcm-gen did not generate C source file"
    system bin/"lcm-gen", "-x", "example_t.lcm"
    assert_predicate testpath/"exlcm/example_t.hpp", :exist?, "lcm-gen did not generate C++ header file"
    system bin/"lcm-gen", "-j", "example_t.lcm"
    assert_predicate testpath/"exlcm/example_t.java", :exist?, "lcm-gen did not generate Java source file"
    system bin/"lcm-gen", "-p", "example_t.lcm"
    assert_predicate testpath/"exlcm/example_t.py", :exist?, "lcm-gen did not generate Python source file"
  end
end
