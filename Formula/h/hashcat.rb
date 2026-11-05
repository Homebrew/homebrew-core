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
    sha256 arm64_golden_gate: "38a531805276812b858abe2b15995e5a9c5141ed81a2abce41a2802878689333"
    sha256 arm64_tahoe:       "f10544272c35b63688c259cb2a86da8c57dc42a13d6946888b05c1b64346ecbc"
    sha256 arm64_sequoia:     "93fbe0438776d0d0763f103f86b74a6c4f5464f332ac1c002cad03125386e44c"
    sha256 arm64_linux:       "276913be2c7c5043bab207c731df894147b8aed3e06f38306af7e5e6dd8332af"
    sha256 x86_64_linux:      "95612765d78ff6b467a7812c3fd12a71e1b939bdce5aceef175d5d5c0208e18b"
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
