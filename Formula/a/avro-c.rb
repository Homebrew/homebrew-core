class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.12.1/c/avro-c-1.12.1.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.12.1/c/avro-c-1.12.1.tar.gz"
  sha256 "b64e31b94719499549622aa92f1d96d1742967ced261a0931b63be3bbe907f2c"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "abb6d682b6136ad799198b11633ab0a197bae12b256ab0ddd5d7d0ea77bf3f41"
    sha256 cellar: :any,                 arm64_sequoia: "44c05e639545cf1f19322088a4becef2a6918d55bd531be545af501dfee7b39c"
    sha256 cellar: :any,                 arm64_sonoma:  "1907a3e4371b719d35b0a56d265d6c7c425d11ec5e4f14ac3a08a9c11ad52580"
    sha256 cellar: :any,                 sonoma:        "f59a5d3deb7314c5c9c1fbb149e7e74470fc6b160b33e4e10dd0c71adff72658"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fa921d188143ffc18e81dd7c664593775e6496d921c85b4a63d6e1fde0b1b81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1c7c2673ab920322902e435fb6b4c562c90b3c5fbbaf1b2f62d15a5e7db1edc"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "jansson"
  depends_on "snappy"
  depends_on "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
