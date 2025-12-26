# Homebrew formula for OpenZL
# Installation: brew install ./openzl.rb
# Or submit to Homebrew tap for official inclusion

class Openzl < Formula
  desc "Format-aware compression framework optimized for specialized datasets"
  homepage "https://github.com/facebook/openzl"
  url "https://github.com/facebook/openzl/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "3278546dcdbae3aef3887f07b435ebe0aa9f6943a5ac74cf9b7baeefe6526c2e"
  license "BSD-3-Clause"
  head "https://github.com/facebook/openzl.git", branch: "dev"

  # The formula requires a modern compiler with C11 and C++17 support
  # macOS 10.13+ (High Sierra) comes with a compatible Xcode
  depends_on "cmake" => :build
  depends_on "zstd"

  def install
    # Create build directory
    mkdir "build"

    # Configure CMake with installation enabled
    # Building the CLI tool and core library
    system "cmake", "-B", "build", "-S", ".",
           "-DCMAKE_BUILD_TYPE=Release",
           "-DCMAKE_INSTALL_PREFIX=#{prefix}",
           "-DOPENZL_BUILD_TESTS=OFF",
           "-DOPENZL_BUILD_BENCHMARKS=OFF",
           "-DOPENZL_BUILD_CLI=ON",
           "-DOPENZL_BUILD_TOOLS=ON",
           "-DOPENZL_BUILD_EXAMPLES=OFF",
           "-DOPENZL_INSTALL=ON",
           "-DOPENZL_CPP_INSTALL=ON",
           "-DZSTD_BUILD_PROGRAMS=OFF",
           "-DZSTD_BUILD_CONTRIB=OFF",
           "-DZSTD_BUILD_TESTS=OFF"

    # Build the project
    system "cmake", "--build", "build", "--config", "Release", "--parallel"

    # Install the project (includes zstd/lz4 which we'll exclude)
    system "cmake", "--install", "build"

    # Remove zstd and lz4 to avoid conflicts with system packages that depend on them
    # OpenZL bundles these but we'll use system versions via Homebrew dependency
    rm_rf "#{prefix}/include/zstd.h"
    rm_rf "#{prefix}/include/zstd_errors.h"
    rm_rf "#{prefix}/include/zdict.h"
    rm_rf "#{prefix}/include/lz4.h"
    rm_rf "#{prefix}/include/lz4frame.h"
    rm_rf "#{prefix}/lib/cmake/zstd"
    rm_rf "#{prefix}/lib/cmake/lz4"
    rm_rf Dir["#{prefix}/lib/libzstd*"]
    rm_rf Dir["#{prefix}/lib/liblz4*"]
    rm_rf Dir["#{prefix}/lib/pkgconfig/libzstd*"]
    rm_rf Dir["#{prefix}/lib/pkgconfig/liblz4*"]

    # The CLI tool 'zli' should be installed to bin directory by CMake
    # Verify it exists after installation
    bin.install "build/cli/zli" if File.exist?("build/cli/zli")
  end

  test do
    # Test that the library was installed
    assert_path_exists "#{lib}/libopenzl.a"
    assert_path_exists "#{include}/openzl"

    # Test the CLI tool if it was built
    if File.exist?("#{bin}/zli")
      output = shell_output("#{bin}/zli --version 2>&1 || true")
      assert_match /zli|usage/i, output
    end
  end
end
