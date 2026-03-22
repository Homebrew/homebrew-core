class Kcov < Formula
  desc "Code coverage tester for compiled programs, Python, and shell scripts"
  homepage "https://simonkagstrom.github.io/kcov/"
  url "https://github.com/SimonKagstrom/kcov/archive/refs/tags/v43.tar.gz"
  sha256 "4cbba86af11f72de0c7514e09d59c7927ed25df7cebdad087f6d3623213b95bf"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/SimonKagstrom/kcov.git", branch: "master"

  # We check the Git tags because, as of writing, the "latest" release on GitHub
  # is a prerelease version (`pre-v40`), so we can't rely on it being correct.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "66b47f9d61f53b74499405515b06143e082dbbb6dc2c7b5c1a5899f70a5e6627"
    sha256 arm64_sequoia: "011a405bdcae2f4b98225fd2acaa344dc8f4e1146d11a1278b57d90fc549c8c1"
    sha256 arm64_sonoma:  "d1f7d21d5295a410fe7f7f1eee6af7893fe25100470079e899129081cd680220"
    sha256 sonoma:        "01edb51341252ffc753b17bdbdb63cf6c352cc2535742aa2f13c2915f07dda07"
    sha256 arm64_linux:   "7038d1494b3b56a5fc8f4d3f0b3bf3960597cd0516bf28bc90a2adf4068689b4"
    sha256 x86_64_linux:  "ad1cff7d8d0f3b6d044604c0ea0c6635048f01a9f2494724a91eac68646135a4"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "dwarfutils"
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "elfutils"
    depends_on "zlib-ng-compat"
  end

  def install
    # Fix to find libdwarf header files
    # Issue ref: https://github.com/SimonKagstrom/kcov/issues/475
    inreplace "cmake/FindDwarfutils.cmake", "libdwarf-0", "libdwarf-#{Formula["dwarfutils"].version.major}"

    system "cmake", "-S", ".", "-B", "build", "-DSPECIFY_RPATH=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello.bash").write <<~EOS
      #!/bin/bash
      echo "Hello, world!"
    EOS

    system bin/"kcov", testpath/"out", testpath/"hello.bash"
    assert_path_exists testpath/"out/hello.bash/coverage.json"
  end
end
