class Lcm < Formula
  desc "Libraries and tools for message passing and data marshalling"
  homepage "https://lcm-proj.github.io/"
  url "https://github.com/lcm-proj/lcm/releases/download/v1.4.0/lcm-1.4.0.zip"
  sha256 "e249d7be0b8da35df8931899c4a332231aedaeb43238741ae66dc9baf4c3d186"
  license "LGPL-2.1"
  revision 6
  head "https://github.com/lcm-proj/lcm.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "b30cc36445aaa0c3b1f5c784608fb4bfcc5e9f2e1d3afa9c5d58c6185340c5e7"
    sha256 cellar: :any,                 arm64_big_sur:  "c7ad845ea866ae04b14650ff23482f4093ba7ab0973bbb920180d201c3b31b80"
    sha256 cellar: :any,                 monterey:       "a05d1bd7f4b43968e99c05f80f0ef707eed4179a5c511a80a5e3fad656b5d666"
    sha256 cellar: :any,                 big_sur:        "0ee183d544cf79575e1d23b84109b3439ab1adf3fc9de53bb726b272658a9dc0"
    sha256 cellar: :any,                 catalina:       "f54ed2743dd01a817b91e881695c5bab06b42123269e5e1586256fb70ab81c62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc2ac51e1a23482d573e071493c49089c7de08be39be0002b523bbccfec4758b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "lua"
  depends_on "openjdk"
  depends_on "python@3.9"

  def install
    # Adding RPATH in #{lib}/lua/X.Y/lcm.so and some #{bin}/*.
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DLCM_ENABLE_EXAMPLES=OFF
      -DLCM_ENABLE_TESTS=OFF
      -DLCM_JAVA_TARGET_VERSION=8
      -DPYTHON_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
