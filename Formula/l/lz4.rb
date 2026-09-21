class Lz4 < Formula
  desc "Extremely Fast Compression algorithm"
  homepage "https://lz4.github.io/lz4/"
  url "https://github.com/lz4/lz4/archive/refs/tags/v1.10.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/lz4-1.10.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/lz4-1.10.0.tar.gz"
  sha256 "537512904744b35e232912055ccf8ec66d768639ff3abe5788d90d792ec5f48b"
  license "BSD-2-Clause"
  head "https://github.com/lz4/lz4.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 3
    sha256 cellar: :any, arm64_golden_gate: "53ea7532077fe43abfe3d6e0d9991ebc8370e9edcc508f997c92902d60c8b151"
    sha256 cellar: :any, arm64_tahoe:       "2be9df952396d89008e56232b065354b3bd51dde5f8a30c1fe18d765ff26e017"
    sha256 cellar: :any, arm64_sequoia:     "91674f1c7407b1f7b73d5bd1d85ed1abaaca93be3b68607af4ef3df632540ac0"
    sha256 cellar: :any, arm64_linux:       "fcb342edff20ec5c0418e4557de93ea6af1a6e0fa8b5d695223816197f60e057"
    sha256 cellar: :any, x86_64_linux:      "9e0b7281ea67651501955030ea0e1b3f4036a6a1b712589f9ac816c545577eae"
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
