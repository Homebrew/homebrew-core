class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "296af5505a35c0cdb488e05314ad1e2824907c10a239841042e42a1279c0f739"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3e9aa4219b05b2247b5d1743a6e86dce4a6fe7d71d66f10b513cb93976d724e0"
    sha256 cellar: :any, arm64_sequoia: "f56176e39159b5ab86744fe4bb106def02657c3e513f516cc4b62eed53e5348c"
    sha256 cellar: :any, arm64_sonoma:  "02963df31c2743c9de290a8b9672af8f978ee9a78228c3a4b444e65e214a37a7"
    sha256 cellar: :any, sonoma:        "07f17e1edaca830e7a920b4765d8f19e9d51e2498c80becfb054525d8bb925ff"
    sha256 cellar: :any, arm64_linux:   "0316502273cc1a4322a770d8085648857bfb6c14f978c60b231177617d8b590f"
    sha256 cellar: :any, x86_64_linux:  "141c90226752395444ba10b8d95258b3c19752bdfc8054a0b32cd31c8a08524c"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600
  end

  fails_with :clang do
    build 1600
    cause "Requires C+++20 support for `std::atomic_ref`"
  end

  fails_with :gcc do
    version "12"
    cause "Requires C++20 std::format, https://gcc.gnu.org/gcc-13/changes.html#libstdcxx"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Remove unwanted headers and libraries for `cppjieba`
    rm_r Dir["{#{include},#{share}}/cppjieba/*"]
  end

  test do
    # Upstream versioning up to patch version, so skip for 4th number in version
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/lbug --version")

    # Test basic query functionality
    output = pipe_output("#{bin}/lbug -m csv -s", "UNWIND [1, 2, 3, 4, 5] as i return i;")
    assert_match "i", output
    assert_match "1", output
    assert_match "2", output
    assert_match "3", output
    assert_match "4", output
    assert_match "5", output
  end
end
