class Kcov < Formula
  desc "Code coverage tester for compiled programs, Python, and shell scripts"
  homepage "https://simonkagstrom.github.io/kcov/"
  url "https://github.com/SimonKagstrom/kcov/archive/v39.tar.gz"
  sha256 "1b538fe16acf5ffd886f1fc32e9e803a520d586666e5c90a0b8632f1459291eb"
  license "GPL-2.0"
  head "https://github.com/SimonKagstrom/kcov.git", branch: "master"

  # We check the Git tags because, as of writing, the "latest" release on GitHub
  # is a prerelease version (`pre-v40`), so we can't rely on it being correct.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 arm64_monterey: "75952c1c6810265bc4031f959607496a47f49038ea2e6a4491e5f727e323298a"
    sha256 arm64_big_sur:  "93ce6e77263bed79a9a53e1e3a8426f91856ae2a431b5d77a249aab30c97fa8c"
    sha256 monterey:       "949ade6c09d7562e5ff39404429ea97f47156e05e6f8fc433e233281464d016b"
    sha256 big_sur:        "5c36eeea756c530f7ebe1af690d5ce74fd873ab85e7b7403f0987e1d12dd76a2"
    sha256 catalina:       "d5f288a2e47be17f364f28140403a77d4cd926fe412480a6485fb396c996d65a"
    sha256 x86_64_linux:   "00d00da79f43b56559291fc131a55090875321bd279b0065382aa27fc9db04f2"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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
