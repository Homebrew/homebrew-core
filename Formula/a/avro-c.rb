class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.12.2/c/avro-c-1.12.2.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.12.2/c/avro-c-1.12.2.tar.gz"
  sha256 "ccc85c5a967ca647fe0961ddeedf286cde00aacf87834d8ca552a0165ae4aa6d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "63961ea73651a271cb6abad08b6b2d939f24b81894f9cc3eea61867c0647f4cc"
    sha256 cellar: :any, arm64_sequoia: "da06912d90d900b39c6d8f85295bc8a1fe86cf387c9206a34f6143dad868b220"
    sha256 cellar: :any, arm64_sonoma:  "cbf93472cc6dd4ecc61da5f2bec6fd5bde61ff4602bcc8065df86c639eaf9080"
    sha256 cellar: :any, sonoma:        "dfb532b3e2dd04e1325c301259d2c4022acf1b159ce38b3317933d95c1c7f980"
    sha256 cellar: :any, arm64_linux:   "92cbdeac44b1fd20ecafdbe8bbd7a5f6f9e8037c920c4190f968f8607521fba9"
    sha256 cellar: :any, x86_64_linux:  "a7562a33b60c43d3255e69bb13cb16c37f9efd1511c86ecd16284c049184da74"
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
