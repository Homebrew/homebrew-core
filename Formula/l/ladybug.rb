class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "f0decf73435d555498868b350214de7f98ec9219a29dffee444690873ae8b09f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2aa34a1fa149f3ea21380f20df9f4bb1d88eed707b09fa927000ed18d07481dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6de2e2856d56539cdebd7652e92d50aca19485695ff53c3db1160f9f013f0198"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18d60071b3c3a4a64b031958e70cc9cf0a495de2246ae1258e48dea4e1ddeac3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3391a7bfddd7b247834a2d1891c5f7242d894cf008dbe4268aca4abe389a0751"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4cbe3c659bcabce524666171e4be97f15cdf8f194a80a249573ed48ba95b3b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3795a34505ce6b8151872bfb85421a2da32574186e7000f5e13644c80629d382"
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
    assert_match version.to_s, shell_output("#{bin}/lbug --version")

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
