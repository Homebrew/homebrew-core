class Lz4 < Formula
  desc "Extremely Fast Compression algorithm"
  homepage "https://lz4.github.io/lz4/"
  url "https://github.com/lz4/lz4/archive/refs/tags/v1.11.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/lz4-1.11.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/lz4-1.11.0.tar.gz"
  sha256 "247e5fa64da5f7b75ee3dd3bed484076396c9ebe8254d9ccf693eb62800c5e26"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://github.com/lz4/lz4.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "464d0e2782c24627a2ffa99093daaf8a7f9e2acbdae1ac4587d8724b85f2dbf9"
    sha256 cellar: :any, arm64_tahoe:       "f25384fe48be399693954cf6b1b48da50ae795a29058ca7abfe91fc4c3e8b623"
    sha256 cellar: :any, arm64_sequoia:     "8c311d5e93bca17d53f8225dd8fabbb2626fa6ade09ff5713e3b85d428fec3bf"
    sha256 cellar: :any, arm64_linux:       "73e9aabe8d8050adae8f0d71946169b0e915fb9d627e956b2377558d48285ae1"
    sha256 cellar: :any, x86_64_linux:      "48865122616cc54135b0605f93ebc56a6fc7aecffb112019e91a90a5893b6903"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "make", "install", "PREFIX=#{prefix}"
    # Prevent dependents from hardcoding Cellar paths.
    inreplace lib/"pkgconfig/liblz4.pc", prefix, opt_prefix

    # We use CMake for package configuration files. These are currently needed to build `tiledb`.
    # The Makefile is used for everything else as official build system and installs multi-threaded CLI.
    ENV["DESTDIR"] = buildpath
    system "cmake", "-S", "build/cmake", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DBUILD_STATIC_LIBS=ON", # for LZ4::lz4_static target
                    "-DLZ4_BUILD_CLI=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build" # needed to run `--install` which rewrites build path in .cmake file
    system "cmake", "--install", "build"
    lib.install File.join(buildpath, lib, "cmake")
  end

  test do
    input = "testing compression and decompression"
    compressed = pipe_output(bin/"lz4", input)
    refute_empty compressed
    decompressed = pipe_output("#{bin}/lz4 -d", compressed)
    assert_equal decompressed, input

    # Make sure lz4 executable is built multi-threaded
    assert_match "multithread", shell_output("#{bin}/lz4 -V")
  end
end
