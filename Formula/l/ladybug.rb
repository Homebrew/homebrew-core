class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "c22417b46b895df7c25f8314cab27bc1afbf1a43b06463a023c98eac5ffe16c3"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "0d4155d639e169913f17d3d1344591948fce00905e8a4398f3d9074a00200da7"
    sha256 cellar: :any,                 arm64_sequoia: "645ba24811550a2e0ebe71ee97e4255beb275d912cdaee3008ffb1d3b492ff43"
    sha256 cellar: :any,                 arm64_sonoma:  "ec2e1557fae4914afc541d1bfafee9b5169fba4eb0d8823d4beb4e7e33ff3919"
    sha256 cellar: :any,                 sonoma:        "86dbdd77ed809cee24b42b309c7ed5ac00ce841cb45beb27883245c2f4309e82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f878af0aa3ca57fc97e5ade8f58d5ee46218918fbd06c7cade5eff84ef61c372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a709d48e720801aa916a482a7c14e70e950a3a97837e6fc8d6f8ba0f77b4f36"
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
