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
    rebuild 2
    sha256 arm64_tahoe:   "e7a4a2f834223bbd0a6cc98fa37c322c50df75e3af42106973cd015c38d80f4f"
    sha256 arm64_sequoia: "1e52f0146178dbee305dce189b2252cc8281bedc8cefaf6f6c0772330009a285"
    sha256 arm64_sonoma:  "a1050a21c04753c0711f77d0cba6cdff0d5df3c64a14f16132faeb9ca89833d1"
    sha256 sonoma:        "f48e951eb2e1d4779cedf97bc64f57dc77c34aa906d17af8952fbf629ae88006"
    sha256 arm64_linux:   "2f87ec3529e895d0023ba9aad41bfa23561ec90f7d078e118f69cf94d1ae1fac"
    sha256 x86_64_linux:  "71e6f0aca36375f3ce64d931210cbcf6e84f28e16d96c0f7af8e80be8e169ce4"
  end

  depends_on "python@3.14" => :build
  depends_on "minizip"
  depends_on "xxhash"

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
    ENV["XDG_DATA_HOME"] = testpath
    mkdir testpath/"hashcat"

    # OpenCL is not supported on virtualized arm64 macOS
    no_opencl = OS.mac? && Hardware::CPU.arm?
    no_metal = !OS.mac?

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
