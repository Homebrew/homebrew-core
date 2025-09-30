class Prjtrellis < Formula
  desc "Documenting the Lattice ECP5 bit-stream format"
  homepage "https://github.com/YosysHQ/prjtrellis"
  url "https://github.com/YosysHQ/prjtrellis/archive/refs/tags/1.4.tar.gz"
  sha256 "46fe9d98676953e0cccf1d6332755d217a0861e420f1a12dabfda74d81ccc147"
  license all_of: ["ISC", "MIT"]
  revision 6

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "def76368a04bec2465e3ce01947b58b3a9d0060cf46ed0bf5850e3e7fd3e373b"
    sha256 cellar: :any,                 arm64_sequoia: "abac927a93238b75de677bdaff112b21cd482615907be087e3e335fa0a03853c"
    sha256 cellar: :any,                 arm64_sonoma:  "46ec19c5a4a03150ba7262824c4b659cfbe1ae055e243de364434664f3b2689c"
    sha256 cellar: :any,                 arm64_ventura: "95d6e9b56cd87332024ddf94fd4803a31e7689f6c38e925dcc5df3c8c256baf1"
    sha256 cellar: :any,                 sonoma:        "95a097f3fdf288586f0a22cbdd913674920e10fc0a531c66febe172ea6454270"
    sha256 cellar: :any,                 ventura:       "c7daafb76a3b406e58b87ac8e85efa9621b5b3155eef4ec84e8e07c758c5d6f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba0cf0a98b6d3aa7253f40d1e4536f1affc0b09b10fd55d0ab08ec762214e9c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5e1a05955c92564b80b5982ae7953abbfede6a7ac3a2cd0fffb6b75804fd245"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "python@3.13"

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
