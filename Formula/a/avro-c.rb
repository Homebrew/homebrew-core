class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  # Upstreams tar.gz can't be opened by bsdtar on macOS
  # https://github.com/Homebrew/homebrew-core/pull/146296#issuecomment-1737945877
  # https://apple.stackexchange.com/questions/197839/why-is-extracting-this-tgz-throwing-an-error-on-my-mac-but-not-on-linux
  url "https://github.com/apache/avro.git",
      tag:      "release-1.11.3",
      revision: "35ff8b997738e4d983871902d47bfb67b3250734"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5b573d22c1090a79e1fbca6318cbdaa497d7114d02cf69aac9fc4aad77b8489f"
    sha256 cellar: :any,                 arm64_sonoma:   "486572382a8323c7816b6244588ecbd2dbf4d39fb1deea0c12600abe86df2f29"
    sha256 cellar: :any,                 arm64_ventura:  "753a5f373fb25d3d992539750fa36b68a981d7529fee9eb6b702090e61dc5939"
    sha256 cellar: :any,                 arm64_monterey: "a67d4adccc1ab3face3d67c7fbfcd85701eefd48d200f6897e4ad05aa91b0b26"
    sha256 cellar: :any,                 sonoma:         "9b78764d59ba53b7472c07367e63f04b3168ddbb0dac230216e4188165285b10"
    sha256 cellar: :any,                 ventura:        "21ab5db9c56aeda49e97fd561116d8e554b7bba66d2d3cb7d19db4cb40fc1852"
    sha256 cellar: :any,                 monterey:       "fe874bc1b1f28d006e362b10543cb63b06ceb99baaa90b1d4ac9c87b33d24ffe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0385f75fb76a3c8bf9cb71e85a0db0c5b1563481ec19afdb6f985a58065c4141"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "snappy"
  depends_on "xz"

  uses_from_macos "zlib"

  def install
    cd "lang/c" do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end
  end

  test do
    resource "homebrew-example" do
      url "https://raw.githubusercontent.com/apache/avro/88538e9f1d6be236ce69ea2e0bdd6eed352c503e/lang/c/examples/quickstop.c"
      sha256 "8108fda370afb0e7be4e213d4e339bd2aabc1801dcd0b600380d81c09e5ff94f"
    end

    testpath.install resource("homebrew-example")
    system ENV.cc, "quickstop.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lavro"
    system "./test", ">> /dev/null"
  end
end
