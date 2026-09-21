class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.20.4.tar.gz"
  sha256 "4c85fa10f60668df3128fa85812a811f72d78fffbc967622986f57dcc7812e62"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "def9f843151522796b4f4130e6b059c079ac23c75a50d530bf616949c7641bb4"
    sha256 cellar: :any, arm64_tahoe:       "0f8b61ad5b481aa86292256109f04a8c6f453dbdb90cd80344523deff70c4984"
    sha256 cellar: :any, arm64_sequoia:     "f16acb68aa27c797b31f494f44446aeaf3cb79c7b5e872041c9510e7cecd5e62"
    sha256 cellar: :any, arm64_linux:       "d3ecb863c00252e43935a741e5190b5d62ac973c9b78010a334b3a254cc989c9"
    sha256 cellar: :any, x86_64_linux:      "9f1a8743c54dcf62cf1553b50f1c6f5d1e4efbb7ecdd7bbc9e5c7129aedc1d56"
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
    args = %W[-DCMAKE_INSTALL_RPATH=#{rpath}]

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
