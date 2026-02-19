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
    rebuild 1
    sha256 arm64_tahoe:   "04938ddb4f29ca141392fcbef86f0c56ef4a1ff7ee443df0dc9330bd37613458"
    sha256 arm64_sequoia: "176202f95fd8029106c44ab68cccca4e16b1361bb57873fbef2781ac32f05246"
    sha256 arm64_sonoma:  "491d1d4b437d54bf68ac5209b9af93d00305789ba55a1292aa3b7a9c3b019c11"
    sha256 sonoma:        "93f83e9b2b9f140d92b8717cd06c05ebb72b8f6ab1abbe155e48a108bdb55ea8"
    sha256 arm64_linux:   "7731ba769d810587420d468e1518c17114c9b0340fc446cb18c6898587772de5"
    sha256 x86_64_linux:  "c6313e643cf002cf3c16b9b075fe5c01880dac49301efcad3960c5023399e322"
  end

  depends_on "python@3.14" => :build
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
