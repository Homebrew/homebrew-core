class Libchaos < Formula
  desc "Advanced library for randomization, hashing and statistical analysis"
  homepage "https://github.com/maciejczyzewski/libchaos"
  url "https://github.com/maciejczyzewski/libchaos/releases/download/v1.0/libchaos-1.0.tar.gz"
  sha256 "29940ff014359c965d62f15bc34e5c182a6d8a505dc496c636207675843abd15"
  license "BSD-2-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "7e6429fc1638909e532b661ade2c4de6747e9ab3210f4b1d887d666af7517179"
    sha256 cellar: :any,                 arm64_sequoia:  "a06f03544d61ba6c17a360992f7397fcb0ed1eafb1027bb561cbe9e71c0bf2ad"
    sha256 cellar: :any,                 arm64_sonoma:   "e6b159ec85602b056a5cae0bda11203c4296f72fa6850e54e94067cf3360263d"
    sha256 cellar: :any,                 arm64_ventura:  "0e01bcaadb5cb22391c9671eed7f0a8a4852717f4ce45962f5bf088bcc025ca9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cbe23d7c195b8cb1e7336596112bb1f84b3579cca069b5bc9b61e41c640e32f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1b5eff28e28622055d915653c66c2448cba0cb207a8b8f243525c2deb1dd246"
    sha256 cellar: :any,                 sonoma:         "f3d5c1a274d22e7d33b85e239bcbbd91e9032a6e4a3dc733b4de47aae84326f2"
    sha256 cellar: :any,                 ventura:        "7941f781d63a2ee566c5c0ba5f171f9f5026d4da819fc111ad3915d631bcd7df"
    sha256 cellar: :any_skip_relocation, monterey:       "018d34f680d426fab143744ab7413cfdb8db204ac5bc0a77de9767a2802bbf5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b51e7e88ad2f47cdb860d3edbf65a9db6a1a0feeefbb46dae978f3b4311f20f"
    sha256 cellar: :any_skip_relocation, catalina:       "8cd295f6ccf1c6a09ab87bef06331424da21b0b44da8f4440a11f4fccaf1370a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3d694020ddee200b924b4c7e82acb8993096e7afd2749c590fecf642302fd6cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1add1c600d4abf7d5cb5e4268810c4f3f8f29a6a4a5ea267c95202230881b8f"
  end

  depends_on "cmake" => :build

  # Support for Xcode 15+ (LLVM 16+)
  patch :DATA

  def install
    args = %w[
      -DLIBCHAOS_ENABLE_TESTING=OFF
      -DSKIP_CCACHE=ON
    ]

    # Workaround to build with CMake 4
    inreplace "CMakeLists.txt", "CMAKE_POLICY(SET CMP0050 OLD)", ""
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "build"
    lib.install "build/libchaos.a"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <chaos.h>
      #include <iostream>
      #include <string>

      int main(void) {
        std::cout << CHAOS_META_NAME(CHAOS_MACHINE_XORRING64) << std::endl;
        std::string hash = chaos::password<CHAOS_MACHINE_XORRING64, 175, 25, 40>(
            "some secret password", "my private salt");
        std::cout << hash << std::endl;
        if (hash.size() != 40)
          return 1;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cc", "-std=c++11", "-L#{lib}", "-lchaos", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/include/chaos/analysis.hh b/include/chaos/analysis.hh
index 2b24d01..57423d1 100755
--- a/include/chaos/analysis.hh
+++ b/include/chaos/analysis.hh
@@ -37,15 +37,17 @@ class basic_adapter {
 	AP adapter;

 public:
+	using result_type = uint32_t;
+
 	void connect(AP func) { adapter = func; }
 	constexpr static size_t max(void) {
-		return std::numeric_limits<uint32_t>::max();
+		return std::numeric_limits<result_type>::max();
 	}
 	constexpr static size_t min(void) {
-		return std::numeric_limits<uint32_t>::lowest();
+		return std::numeric_limits<result_type>::lowest();
 	}
-	uint32_t operator()(void) noexcept {
-		return (uint32_t)(adapter() * (double)UINT32_MAX);
+	result_type operator()(void) noexcept {
+		return (result_type)(adapter() * (double)max());
 	}
 };
