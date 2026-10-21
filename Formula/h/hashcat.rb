class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files/hashcat-7.1.2.tar.gz"
  mirror "https://github.com/hashcat/hashcat/archive/refs/tags/v7.1.2.tar.gz"
  sha256 "9546a6326d747530b44fcc079babad40304a87f32d3c9080016d58b39cfc8b96"
  license all_of: [
    "MIT",
    "LZMA-SDK-9.22", # deps/LZMA-SDK/
    :public_domain,  # include/sort_r.h
  ]
  version_scheme 1
  head "https://github.com/hashcat/hashcat.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?hashcat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 3
    sha256 arm64_golden_gate: "cc3fc40438facc4020562175bc2b93b73c0243828aefb7a21f7bcc0aaf3bc59e"
    sha256 arm64_tahoe:       "9660281ddadbd08f981600044f9ab8a77bb94251709b5465904c545ad8bdbc31"
    sha256 arm64_sequoia:     "5b76d2a56bcb712905529d4ee1cbc5f8e16b7cdcfbc1f7a79812e4124bae9258"
    sha256 arm64_linux:       "edf1ba68b54f13e2bfa8f5e7414eb8d5ca30d7397e07d05ad210b104772537cd"
    sha256 x86_64_linux:      "41ce78c2f40c40e00421b5706eace1feec56624fcce3cfef94432617cacf16a9"
  end

  depends_on "minizip"
  depends_on "xxhash"

  uses_from_macos "python"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "opencl-icd-loader"
    depends_on "pocl"
    depends_on "zlib-ng-compat"
  end

  def install
    # Remove some bundled dependencies that are not needed
    (buildpath/"deps").each_child do |dep|
      rm_r(dep) if %w[OpenCL-Headers unrar xxHash zlib].include?(dep.basename.to_s)
    end
    (buildpath/"docs/license_libs").each_child do |dep|
      rm(dep) unless %w[SSE2NEON LZMA].any? { |dep_name| dep.basename.to_s.start_with?(dep_name) }
    end

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
    mv bin/"hashcat", bin/"hashcat_bin"
    (bin/"hashcat").write_env_script bin/"hashcat_bin", XDG_DATA_HOME: share
  end

  test do
    ENV["XDG_CACHE_HOME"] = testpath
    ENV["XDG_DATA_HOME"] = testpath
    (testpath/"hashcat").mkpath

    # OpenCL is not supported on virtualized arm64 macOS
    # Metal on macOS 27 doesn't seem to work yet
    no_opencl = OS.mac? && Hardware::CPU.virtualized?
    no_metal = !OS.mac? || MacOS.version >= :golden_gate

    args = %w[
      --benchmark
      --hash-type=0
      --workload-profile=2
    ]
    args << (no_opencl ? "--backend-ignore-opencl" : "--opencl-device-types=1,2")
    args << "--backend-ignore-metal" if OS.mac? && no_metal

    if no_opencl && no_metal
      no_platform_message = "No OpenCL, Metal, HIP or CUDA compatible platform found"
      assert_match no_platform_message, shell_output("#{bin}/hashcat_bin #{args.join(" ")} 2>&1", 255)
    else
      assert_match "Hash-Mode 0 (MD5)", shell_output("#{bin}/hashcat_bin #{args.join(" ")}")
    end

    assert_match version.to_s, shell_output("#{bin}/hashcat_bin --version")
  end
end
