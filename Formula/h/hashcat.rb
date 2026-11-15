class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files/hashcat-8.0.0.tar.gz"
  mirror "https://github.com/hashcat/hashcat/archive/refs/tags/v8.0.0.tar.gz"
  sha256 "d6a7533e1e250a236a8b99d0b725cdd76d8fdce744c7eeacb2bf42210fe4761b"
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
    rebuild 1
    sha256 arm64_golden_gate: "98924135cea4a887449031a186fcc22d8967572c25061f9b55029c86146b8099"
    sha256 arm64_tahoe:       "38daa2ea7751cecfe4b549e29dd0cdbe37b50d8843e50d563d3249a009d9b1de"
    sha256 arm64_sequoia:     "4fbcff6248005a9a3b08b37317ebfb77d1f009a2c1a04ebb9dc304c00fc1e035"
    sha256 arm64_linux:       "357f13c840cb85216ad65d3b05eb62ee8bf070d40ff28c39901e0818749ec6dd"
    sha256 x86_64_linux:      "a00c85a7af9fe4673a7507c69256063aaba49edfffe0b5f4d90b42c59234ab76"
  end

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
    rm_r buildpath/"deps/OpenCL-Headers"
    # The ZC706 bootloader is board firmware, so retain its redistribution notices.
    (buildpath/"docs/license_libs").each_child do |dep|
      rm(dep) unless %w[SSE2NEON LZMA XILINX_FSBL].any? { |dep_name| dep.basename.to_s.start_with?(dep_name) }
    end

    args = %W[
      CC=#{ENV.cc}
      COMPTIME=#{ENV["SOURCE_DATE_EPOCH"]}
      PREFIX=#{prefix}
      USE_SYSTEM_OPENCL=1
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
    no_opencl = OS.mac? && Hardware::CPU.virtualized?

    args = %w[
      --benchmark
      --hash-type=0
      --workload-profile=2
    ]
    args << (no_opencl ? "--backend-ignore-opencl" : "--opencl-device-types=1,2")
    # Metal fails to find included kernel headers on current macOS, https://github.com/hashcat/hashcat/issues/4968
    args << "--backend-ignore-metal" if OS.mac?

    if no_opencl
      no_platform_message = "No OpenCL, Metal, HIP or CUDA compatible platform found"
      assert_match no_platform_message, shell_output("#{bin}/hashcat_bin #{args.join(" ")} 2>&1", 255)
    else
      assert_match "Hash-Mode 0 (MD5)", shell_output("#{bin}/hashcat_bin #{args.join(" ")}")
    end

    assert_match version.to_s, shell_output("#{bin}/hashcat_bin --version")
  end
end
