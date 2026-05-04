class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "c22417b46b895df7c25f8314cab27bc1afbf1a43b06463a023c98eac5ffe16c3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bff0dd421557c382367c5e92603052f13aa3677a2a8b94b80854662aa7782dfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc12007816382652304cb6b10690bca1494e87933465768c25c4d5ac6a7f95bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76e87607ee1f1096f6d9aff58ed7964e75f81f11a8c10397609a49ad8720d7be"
    sha256 cellar: :any_skip_relocation, sonoma:        "c40a555a7a30a9075869e92a31f0bbc199fb2684d4ef0cb062f6029483d86e00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8deea46d03d4ee1413c717e23e57c1519316c45e1542da84d6dc2cba77af275b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a004bcd8abb8c8be44a6bd4caf6bb5007f4664bcd581c3256af1d3b4dbf68c2a"
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
