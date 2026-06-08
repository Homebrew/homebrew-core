class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "fcd790936fe83650f6579c741fe79ce295604bbcab905fa389fdc778da83377f"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "b198fe97227451de96bf723be14f1c8813b3066363ca6be42f9f562faa9bee4f"
    sha256 cellar: :any, arm64_sequoia: "a6e3492d5ee00867ff5b2abb926b43da76536109538b6541c461d6a7e98b1f75"
    sha256 cellar: :any, arm64_sonoma:  "663f6250fad9521ed14c67f860e0a047be118fbb94b91eeb7bb4ec58f6cf21c4"
    sha256 cellar: :any, sonoma:        "69b7769b68c458985dd59e3f6dfe5b60aa9c3ae02e41af79264b686747741eb4"
    sha256 cellar: :any, arm64_linux:   "7d4b4668820173cf482125121d8cb4f4ebd0d1e1d1886391d3fa995dfd0a07a3"
    sha256 cellar: :any, x86_64_linux:  "d839b21b9f05e8ec5b85ca6d739cd7d26cad332417b171a88bcd60a20d4aa4c8"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

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
