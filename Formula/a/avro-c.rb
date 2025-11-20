class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.12.1/c/avro-c-1.12.1.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.12.1/c/avro-c-1.12.1.tar.gz"
  sha256 "b64e31b94719499549622aa92f1d96d1742967ced261a0931b63be3bbe907f2c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bbdf1ec9340996a46133cdb5c069d0fa413f0998a05c7ff4589d1e6ae5a43a51"
    sha256 cellar: :any,                 arm64_sequoia: "cc17f9907b085d176a5726058a266f0c251c3fbe64bddccbfa2c1cec17d9c06a"
    sha256 cellar: :any,                 arm64_sonoma:  "0b67b5f253ad41f9c2e13d79179987140a5072ceec7aa37460c2c9e3fa06f229"
    sha256 cellar: :any,                 sonoma:        "3c17d0b642d61939628c80f9a3fc6ef200b06d735bb7bf3a80007e6adf0aab1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ac05bd00f42b859e03b56503b0942c6cb423a0205ab4c444fd962994293347e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55f8e43ea2d0386f33e078a3238886d1de56e4fe843a3e4e0c525179b7189698"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "jansson"
  depends_on "snappy"
  depends_on "xz"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-example" do
      url "https://raw.githubusercontent.com/apache/avro/88538e9f1d6be236ce69ea2e0bdd6eed352c503e/lang/c/examples/quickstop.c"
      sha256 "8108fda370afb0e7be4e213d4e339bd2aabc1801dcd0b600380d81c09e5ff94f"
    end

    testpath.install resource("homebrew-example")
    system ENV.cc, "quickstop.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lavro"
    assert_match "Silent |  (555) 123-6422 | 29 |", shell_output("./test")
  end
end
