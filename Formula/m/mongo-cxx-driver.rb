class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/releases/download/r3.10.1/mongo-cxx-driver-r3.10.1.tar.gz"
  sha256 "0297d9d1a513f09438cc05254b14baa49edd1fa64a6ce5d7a80a1eb7677cf2be"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f56beb3e05d56bb3df788e02e85b626694764648290803d604e9de9b46b6a0f6"
    sha256 cellar: :any,                 arm64_ventura:  "0c37ecaee4a66cbc841d48ab3ac675812a4ad1976ceb826633438d0ec2b031ad"
    sha256 cellar: :any,                 arm64_monterey: "564b92ec4b596495b30f3083ef53f57a38d5538fbc5422948a5a3af42aa3c5f2"
    sha256 cellar: :any,                 sonoma:         "68985adcb44ebe76e80d49b26d3c2293351b7a19b8eaab111a68d6cc089c3d8c"
    sha256 cellar: :any,                 ventura:        "ac68fac94ebc369670708ffbae468509b742868c619c2a5af6be3e1015d2c321"
    sha256 cellar: :any,                 monterey:       "659dd17c8b44e267beb8ca82a3a9b46ae259e04957cb7ae85aa94488ac5abd39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d731bedde0f3513e41647fd9e06c1d0ce453eef7f0104e20463b435bf4d6687a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test
  depends_on "mongo-c-driver"

  def install
    # We want to avoid shims referencing in examples,
    # but we need to have examples/CMakeLists.txt file to make cmake happy
    pkgshare.install "examples"
    (buildpath / "examples/CMakeLists.txt").write ""

    mongo_c_prefix = Formula["mongo-c-driver"].opt_prefix
    args = %W[
      -DBUILD_VERSION=#{version}
      -DLIBBSON_DIR=#{mongo_c_prefix}
      -DLIBMONGOC_DIR=#{mongo_c_prefix}
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    pkg_config_flags = shell_output("pkg-config --cflags --libs libbsoncxx").chomp.split
    system ENV.cc, "-std=c++11", pkgshare/"examples/bsoncxx/builder_basic.cpp",
      *pkg_config_flags, "-lstdc++", "-o", "test"
    system "./test"

    pkg_config_flags = shell_output("pkg-config --cflags --libs libbsoncxx libmongocxx").chomp.split
    system ENV.cc, "-std=c++11", pkgshare/"examples/mongocxx/connect.cpp",
      *pkg_config_flags, "-lstdc++", "-o", "test"
    assert_match "No suitable servers",
      shell_output("./test mongodb://0.0.0.0 2>&1", 1)
  end
end
