class Lcm < Formula
  desc "Libraries and tools for message passing and data marshalling"
  homepage "https://lcm-proj.github.io/"
  url "https://github.com/lcm-proj/lcm/releases/download/v1.4.0/lcm-1.4.0.zip"
  sha256 "e249d7be0b8da35df8931899c4a332231aedaeb43238741ae66dc9baf4c3d186"
  license "LGPL-2.1"
  revision 7
  head "https://github.com/lcm-proj/lcm.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a9fd491e4ac81b5ac1d6e53f4c878c0e99ae93e1ef35a1fb1db57a4c215fa961"
    sha256 cellar: :any,                 arm64_big_sur:  "900f60952dde555d041ffcd3ed4cb531e7f444de49f0ea394530c40c691d2a10"
    sha256 cellar: :any,                 monterey:       "cf6d8a33a2a4e9759453f0d83d8f70f94d15871a093fa2689414f7385ade3d5d"
    sha256 cellar: :any,                 big_sur:        "07b9ccb0e05db6969b1dad98dbda75df66851a34a84157bd7c4f487b8a07439c"
    sha256 cellar: :any,                 catalina:       "ed606aa227cf0de039cf27e070fd76273242fcc2bda96f8705a75dcb73194676"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32cedab1ef9208cdd44df820032e093b533d11cd9eb3391c7dde04b25a4a8d95"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "lua"
  depends_on "openjdk"
  depends_on "python@3.10"

  def install
    # Adding RPATH in #{lib}/lua/X.Y/lcm.so and some #{bin}/*.
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DLCM_ENABLE_EXAMPLES=OFF
      -DLCM_ENABLE_TESTS=OFF
      -DLCM_JAVA_TARGET_VERSION=8
      -DPYTHON_EXECUTABLE=#{which("python3.10")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
