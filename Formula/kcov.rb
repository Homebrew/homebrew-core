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
    sha256 arm64_ventura:  "b56293d52b8d2b3591baccec7f8143aec6fe9b8dc832c5accf5c92fd92f6f3c5"
    sha256 arm64_monterey: "68a6853a5064d77b60aa89e7b1767b9be1505a5c848e9012be017c6d11d55272"
    sha256 arm64_big_sur:  "f9d812f5775df049096ab757479b152f7fc3ccedf25ed18fdec9e027f7210712"
    sha256 ventura:        "d7a061859b7948722c56dd458509476340eee62d4aacd5c496cc8d2514e559e5"
    sha256 monterey:       "3a4aa6158fcf675c5246ae2b45dba40e5054692cb26c6eeabae907293a016ad1"
    sha256 big_sur:        "8ab0e4c6e2716dbf7d8ee4382c06af38d2312e9f877366a05e2529913592747c"
    sha256 x86_64_linux:   "aa3efcf2ba34eb00534fe3a16c8d1dd3e53476dca3819744b9b3f1e8f826df66"
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
