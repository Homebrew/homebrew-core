class Lcm < Formula
  desc "Libraries and tools for message passing and data marshalling"
  homepage "https://lcm-proj.github.io/"
  url "https://github.com/lcm-proj/lcm/releases/download/v1.4.0/lcm-1.4.0.zip"
  sha256 "e249d7be0b8da35df8931899c4a332231aedaeb43238741ae66dc9baf4c3d186"
  license "LGPL-2.1"
  revision 4
  head "https://github.com/lcm-proj/lcm.git"

  bottle do
    cellar :any
    sha256 "aa4335f0aebe0e8cd91d939d682dbf04ee7f25461967b377ff75133717be9fd4" => :catalina
    sha256 "8186cc599f880aa2028db0af661119beb7fa8a4422557d63837ab2937d265af5" => :mojave
    sha256 "46c787c483e3f1c9cfb62b64c3ffab3b83688d00156046d67208071b9b048e8a" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "lua"
  depends_on "openjdk"
  depends_on "python@3.8"

  def install
    args = std_cmake_args + %W[
      -DLCM_ENABLE_EXAMPLES=OFF
      -DLCM_ENABLE_TESTS=OFF
      -DLCM_JAVA_TARGET_VERSION=8
      -DPYTHON_EXECUTABLE=#{Formula["python@3.8"].opt_bin}/python3
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
