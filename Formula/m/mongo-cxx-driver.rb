class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/releases/download/r4.1.2/mongo-cxx-driver-r4.1.2.tar.gz"
  sha256 "613db982dcfa7128cf467a35eead9e9ed9bf4973706479fff92f79a2e7d59cd2"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "87e730928edb68a30ba7dc07fce784f1f4425966ab62a26e43f3823095490983"
    sha256 cellar: :any,                 arm64_sequoia: "47b5fd01b93e1e374c341d0edb6eabebb4c04558685b6ab2b95818a85463174e"
    sha256 cellar: :any,                 arm64_sonoma:  "8d37aaa34f69a3e968ecee5a9cb5352e8439a72a1ed3aad4987b222097aac30f"
    sha256 cellar: :any,                 arm64_ventura: "19c178b1b78adc031b084b0ed8707899c168e635b00c1ca9ff8783b40a319b7b"
    sha256 cellar: :any,                 sonoma:        "c2a24c82811f7aeca65cf286e745ab60ac19f7369c6d84f80c6fd4c46fcfb654"
    sha256 cellar: :any,                 ventura:       "7edd140790503c3efb2de9e015294f17ca4e351d87d01a91d89f96dfcd624633"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ace922e700cf58c507ae4b442b82e7e1f073b5242393ebfaf743e26c0569e5ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e202e337a5106f4c9c07d52c6a91723d2541c1e7b9312b49f551751aaa9ae86"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
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
    pkgconf_flags = shell_output("pkgconf --cflags --libs libbsoncxx").chomp.split
    system ENV.cc, "-std=c++11", pkgshare/"examples/bsoncxx/builder_basic.cpp",
                   "-I#{pkgshare}", *pkgconf_flags, "-lstdc++", "-o", "test"
    system "./test"

    pkgconf_flags = shell_output("pkgconf --cflags --libs libbsoncxx libmongocxx").chomp.split
    system ENV.cc, "-std=c++11", pkgshare/"examples/mongocxx/connect.cpp",
                   "-I#{pkgshare}", *pkgconf_flags, "-lstdc++", "-o", "test"
    assert_match "No suitable servers", shell_output("./test mongodb://0.0.0.0 2>&1", 1)
  end
end
