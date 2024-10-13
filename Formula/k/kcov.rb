class Kcov < Formula
  desc "Code coverage tester for compiled programs, Python, and shell scripts"
  homepage "https://simonkagstrom.github.io/kcov/"
  url "https://github.com/SimonKagstrom/kcov/archive/refs/tags/v43.tar.gz"
  sha256 "4cbba86af11f72de0c7514e09d59c7927ed25df7cebdad087f6d3623213b95bf"
  license "GPL-2.0-or-later"
  head "https://github.com/SimonKagstrom/kcov.git", branch: "master"

  # We check the Git tags because, as of writing, the "latest" release on GitHub
  # is a prerelease version (`pre-v40`), so we can't rely on it being correct.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 arm64_sequoia:  "8687e60acb3aa483967eefded7ad447f69f322af6ce818d183adf1d51eacdf02"
    sha256 arm64_sonoma:   "94d6789bde6e8890e31d5b572b72fac76ade148172c0899c502349678c5835bf"
    sha256 arm64_ventura:  "9b67dcb9cc579b68aff46237a149dce6e17f7be5b584b5a9f2b162858b80e29a"
    sha256 arm64_monterey: "791011db4ed3b46ab785f7553249de53f848841aeecba334a5a35766e7e80bca"
    sha256 sonoma:         "2c1319f3032eed31ecd3c41452383a525a44b1a2aa4e7a0a2c0a9094d0e58f91"
    sha256 ventura:        "62dfd4348ff4fe56aeb5960c04c5e52f25dd3605964c6d9f4a7e460e3b34ff90"
    sha256 monterey:       "b7205b776c7509a7fa80a4788308604ec44b8bb37496716e547ee7fc0dad1ab4"
    sha256 x86_64_linux:   "e2854f13f8bf4b6ff6db16c274f95e558eaa9bd61e80f0074556c543b6a4ac5f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "dwarfutils"
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "elfutils"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DSPECIFY_RPATH=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello.bash").write <<~EOS
      #!/bin/bash
      echo "Hello, world!"
    EOS

    system bin/"kcov", testpath/"out", testpath/"hello.bash"
    assert_predicate testpath/"out/hello.bash/coverage.json", :exist?
  end
end
