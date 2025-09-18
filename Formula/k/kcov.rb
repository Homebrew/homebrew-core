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
    sha256 arm64_tahoe:   "004325cd43501f846fe5f5ffb535bc09101f5905e2e8927f573aee70d9f942ad"
    sha256 arm64_sequoia: "27ca5bd266a2abb7d98cc23a1a15eac0484e46efe80d39227089b8b1ff013e48"
    sha256 arm64_sonoma:  "8155c77528de98a10e48bf62182e200fa95a00c740bdba34d16cdc0867c183c2"
    sha256 arm64_ventura: "9411f9d590330287c00cd1ddb6d73611d788b602d777456f66b830e16af20ecf"
    sha256 sonoma:        "836ef66f3ef803b9e1739ca8c763481f94cfff677fe6d8df5757c2c641000d4e"
    sha256 ventura:       "59a2e4f33e2ceaadb3ab0f3493ba9d5ac2963548db22925947a87df7b666b69a"
    sha256 arm64_linux:   "d1f587bb30ed242db9d735b8c704661649f8a33c7eed1b83f899288333ecf9a2"
    sha256 x86_64_linux:  "ae7dce32c566b2a2f5af67764737d4513973c2facb9070794aa6d58b423b6918"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "dwarfutils"
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "elfutils"
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
