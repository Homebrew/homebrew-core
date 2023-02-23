class Kcov < Formula
  desc "Code coverage tester for compiled programs, Python, and shell scripts"
  homepage "https://simonkagstrom.github.io/kcov/"
  url "https://github.com/SimonKagstrom/kcov/archive/v41.tar.gz"
  sha256 "13cddde0c6c97dc78ece23f7adcad7a8f2b5ae3c84193020e7edd9bf44e5997c"
  license "GPL-2.0-or-later"
  head "https://github.com/SimonKagstrom/kcov.git", branch: "master"

  # We check the Git tags because, as of writing, the "latest" release on GitHub
  # is a prerelease version (`pre-v40`), so we can't rely on it being correct.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "b3d18d99bb52abf6819a97acd9370b67eeeb3de82eda769c4747a92ee4fe8c58"
    sha256 arm64_monterey: "de81e655bc9e9449753e2a728a1c91110fb56584cc3e130e12b029caf87b0020"
    sha256 arm64_big_sur:  "4811a3727f2a5b14515ee453cccc37aa2311d6e912bc7e864b3859559552bcf9"
    sha256 ventura:        "5abb91118339f3cb55d0fae35d8b888a98221d3b6bfa429b67b3d933e74ff2a6"
    sha256 monterey:       "e3c329138996b0aa1076925e7f0a828201cd432882a4c7dac4623ca0e5beba0f"
    sha256 big_sur:        "f3d2355fc81fa4d85009ff34f89c6e67d0848794035fffdc778db08209f30166"
    sha256 x86_64_linux:   "9bbfb939ba3a961e47e1062d30ec5a3bf05277a81450c2ff5149882a8ac691b5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "openssl@3"

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
    system "#{bin}/kcov", testpath/"out", testpath/"hello.bash"
    assert_predicate testpath/"out/hello.bash/coverage.json", :exist?
  end
end
