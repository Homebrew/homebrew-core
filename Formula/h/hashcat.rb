class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files/hashcat-6.2.6.tar.gz"
  mirror "https://github.com/hashcat/hashcat/archive/refs/tags/v6.2.6.tar.gz"
  sha256 "b25e1077bcf34908cc8f18c1a69a2ec98b047b2cbcf0f51144dcf3ba1e0b7b2a"
  license all_of: [
    "MIT",
    "LZMA-SDK-9.22", # deps/LZMA-SDK/
    :public_domain,  # include/sort_r.h
  ]
  revision 1
  version_scheme 1
  head "https://github.com/hashcat/hashcat.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?hashcat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "06e83f034f4146c057190a75ea05d9ede88a2205db694dacf643d7e4d88b8210"
    sha256 arm64_sonoma:   "8b1640f18f1fcf6049869f3e461979401f811b1f46d1131676b0732a8b799c7b"
    sha256 arm64_ventura:  "9b4475b3b7384c8186f3e42e1cef42df899148ecb496f1fdea5c1184773cee6d"
    sha256 arm64_monterey: "d05a3da7fe49d7010b867b3fcfd5b71210a4013d1069a6eca4bb1085dec342ab"
    sha256 sonoma:         "2c7627ab1623911e96f599e9c3cd2e7a29fd53ad3df2b280fb9a39433db8ce72"
    sha256 ventura:        "ebba1034f159a47591071da81c48fa08dfd79416599d4540da0b01ea974d1aa3"
    sha256 monterey:       "1f2d0c9bfb3c3b723a27448e9b26377287b4da0aed331c7f1df80e18a29b9089"
    sha256 x86_64_linux:   "efd1c1f00684129f650a86d10c78873d44535502724731b5eca1976e8624d249"
  end

  depends_on macos: :high_sierra # Metal implementation requirement
  depends_on "minizip"
  depends_on "xxhash"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  # Fix 'failed to create metal library' on macos
  # extract from hashcat version 66b22fa, remove this patch when version released after 66b22fa
  # hashcat 66b22fa link: https://github.com/hashcat/hashcat/commit/66b22fa64472b4d809743c35fb05fc3c993a5cd2#diff-1eece723a1d42fd48f0fc4f829ebbb4a67bd13cb3499f49196f801ee9143ee83R15
  patch :DATA

  def install
    # Remove all bundled dependencies other than LZMA-SDK (https://www.7-zip.org/sdk.html)
    (buildpath/"deps").each_child { |dep| rm_r(dep) if dep.basename.to_s != "LZMA-SDK" }
    (buildpath/"docs/license_libs").each_child { |dep| rm(dep) unless dep.basename.to_s.start_with?("LZMA") }

    args = %W[
      CC=#{ENV.cc}
      COMPTIME=#{ENV["SOURCE_DATE_EPOCH"]}
      PREFIX=#{prefix}
      USE_SYSTEM_XXHASH=1
      USE_SYSTEM_OPENCL=1
      USE_SYSTEM_ZLIB=1
      ENABLE_UNRAR=0
    ]
    system "make", *args
    system "make", "install", *args
    bin.install "hashcat" => "hashcat_bin"
    (bin/"hashcat").write_env_script bin/"hashcat_bin", XDG_DATA_HOME: share
  end

  test do
    ENV["XDG_DATA_HOME"] = testpath
    mkdir testpath/"hashcat"

    # OpenCL is not supported on virtualized arm64 macOS
    no_opencl = OS.mac? && Hardware::CPU.arm? && Hardware::CPU.virtualized?
    # MTLCreateSystemDefaultDevice() isn't supported on GitHub runners.
    # Ref: https://github.com/actions/runner-images/issues/1779
    no_metal = !OS.mac? || ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    args = %w[
      --benchmark
      --hash-type=0
      --workload-profile=2
    ]
    args << (no_opencl ? "--backend-ignore-opencl" : "--opencl-device-types=1,2")

    if no_opencl && no_metal
      assert_match "No devices found/left", shell_output("#{bin}/hashcat_bin #{args.join(" ")} 2>&1", 255)
    else
      assert_match "Hash-Mode 0 (MD5)", shell_output("#{bin}/hashcat_bin #{args.join(" ")}")
    end

    assert_equal "v#{version}", shell_output("#{bin}/hashcat_bin --version").chomp
  end
end

__END__
diff --git a/OpenCL/inc_vendor.h b/OpenCL/inc_vendor.h
index c39fce952..0916a30b3 100644
--- a/OpenCL/inc_vendor.h
+++ b/OpenCL/inc_vendor.h
@@ -12,7 +12,7 @@
 #define IS_CUDA
 #elif defined __HIPCC__
 #define IS_HIP
-#elif defined __METAL_MACOS__
+#elif defined __METAL__
 #define IS_METAL
 #else
 #define IS_OPENCL
