class Lz4 < Formula
  desc "Extremely Fast Compression algorithm"
  homepage "https://lz4.github.io/lz4/"
  url "https://github.com/lz4/lz4/archive/refs/tags/v1.11.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/lz4-1.11.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/lz4-1.11.1.tar.gz"
  sha256 "683fed08a844ad012196381e40badf80c0bbe4962959761416d41c9e67d77ec7"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://github.com/lz4/lz4.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b2422bda202e4a59007a9189493902ac7a75423640081da43de9281a89770d5c"
    sha256 cellar: :any, arm64_tahoe:       "9ab0175d769ca830f573defafb22b020f3e9b4e0862ee6ee9f47e0b46a29468d"
    sha256 cellar: :any, arm64_sequoia:     "69c0c38e660f81b36bbd165a77d7619d2b8b6b175bf670a4840aaaaddd86a520"
    sha256 cellar: :any, arm64_linux:       "14205882471527eb17656af9519512f70b76e9f944f6b68f3395253a175e15f4"
    sha256 cellar: :any, x86_64_linux:      "f89740f8da822dda3870cefc3993db46d721944f4c8eb10755aee79ec5b0706e"
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
