class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "c22417b46b895df7c25f8314cab27bc1afbf1a43b06463a023c98eac5ffe16c3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23a4b409cf2021ec7ef211b85bd7d6ec9b01a7e5adfdbae6f04762f08f3ae6a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "421f80b88bcc9f1b9bfec6f800d27b0655409ad3d597df77d773ba18ab217d95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23c74e8655853c62d5a66a779bffdf6412d6b212fe1b0fa298ec41d39f4874aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "803c9b265e630d487b5b622fd2ca72330fc659ff5aa6713c040cc3f5c974f57a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dd6e9535bcb309434bf53c3e9da2b29742da72ab87a2d2e4b202e4835965b8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11982da506c602bcd6998a918d64e4816b9d61fd40725a23d10e3efd68ab8bfe"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  on_linux do
    depends_on "gcc"
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
    bin.install "build/tools/shell/lbug"
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
