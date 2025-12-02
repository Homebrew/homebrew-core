class Prjtrellis < Formula
  desc "Documenting the Lattice ECP5 bit-stream format"
  homepage "https://github.com/YosysHQ/prjtrellis"
  url "https://github.com/YosysHQ/prjtrellis/archive/refs/tags/1.4.tar.gz"
  sha256 "46fe9d98676953e0cccf1d6332755d217a0861e420f1a12dabfda74d81ccc147"
  license all_of: ["ISC", "MIT"]
  revision 7

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a6b7ec5be496ea0d129abfd976de357fe0c84ce34d95f7b21640b1ad8308fae8"
    sha256 cellar: :any,                 arm64_sequoia: "945c15148287fb63e62ca3773572f2cb6abcc13c6eb82c06356c0ced7b075496"
    sha256 cellar: :any,                 arm64_sonoma:  "55776f6d948b1c99b15b6f84c75296f5324a0fda317f2c2c0946718ca4621257"
    sha256 cellar: :any,                 sonoma:        "81c233a5b2325a8c60c88a5dc097e65f7e901f253c9d8fb4884ed1303f6b4707"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7234b8ff08a258b6cd47965db615ae6a923a1880f4a7660dd6bd550518906a29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e56f2ed4c1a258ae7024c507e51d74093bc89f3f456a62affdd70b92fbe275fe"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "python@3.14"

  resource "prjtrellis-db" do
    url "https://github.com/YosysHQ/prjtrellis/releases/download/1.4/prjtrellis-db-1.4.zip"
    sha256 "4f8a8a5344f85c628fb3ba3862476058c80bcb8ffb3604c5cca84fede11ff9f0"
  end

  # Workaround to build with Boost 1.89.0 until fixed upstream
  # Issue ref: https://github.com/YosysHQ/prjtrellis/issues/251
  patch :DATA

  def install
    (buildpath/"database").install resource("prjtrellis-db")

    system "cmake", "-S", "libtrellis", "-B", "libtrellis",
                    "-DCURRENT_GIT_VERSION=#{version}", *std_cmake_args
    system "cmake", "--build", "libtrellis"
    system "cmake", "--install", "libtrellis"
  end

  test do
    resource "homeebrew-ecp-config" do
      url "https://www.trabucayre.com/blink.config"
      sha256 "394d71ba416517cceee5135b853dd1e94f99b07d5e9a809760618fa820d32619"
    end

    testpath.install resource("homeebrew-ecp-config")

    system bin/"ecppack", testpath/"blink.config", testpath/"blink.bit"
    assert_path_exists testpath/"blink.bit"

    system bin/"ecpunpack", testpath/"blink.bit", testpath/"foo.config"
    assert_path_exists testpath/"foo.config"

    system bin/"ecppll", "-i", "12", "-o", "24", "-f", "pll.v"
    assert_path_exists testpath/"pll.v"

    system bin/"ecpbram", "-g", "ram.hex", "-w", "16", "-d", "512"
    assert_path_exists testpath/"ram.hex"
  end
end

__END__
diff --git a/libtrellis/CMakeLists.txt b/libtrellis/CMakeLists.txt
index b4f02c7..02242d2 100644
--- a/libtrellis/CMakeLists.txt
+++ b/libtrellis/CMakeLists.txt
@@ -46,7 +46,7 @@ if (WASI)
     endif()
 endif()
 
-set(boost_libs filesystem program_options system)
+set(boost_libs filesystem program_options)
 if (Threads_FOUND)
     list(APPEND boost_libs thread)
 else()
