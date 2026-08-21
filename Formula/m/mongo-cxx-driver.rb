class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/releases/download/r4.5.0/mongo-cxx-driver-r4.5.0.tar.gz"
  sha256 "327ec3f5b129abcf15adfa3177270fb41c23a794801d63f56e3292f5eb5c3dc9"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fcfbf98d97c12eb3932f4a748dbfce74234fd0c7f9843ae0bf3da7df86a26da8"
    sha256 cellar: :any, arm64_sequoia: "40d948c35bbc7f0b10d86dbb4eee4cfb6b077dd947db3bad4c587b705a2e9d1c"
    sha256 cellar: :any, arm64_sonoma:  "45dad8b0f5d25508219cd663da39d9e07aa68c889a8baf78baee15dde197a0e0"
    sha256 cellar: :any, sonoma:        "d93371b80062d4b9d01e59db33f65ae6dc947d4be7e1832073129e73ecebcecd"
    sha256 cellar: :any, arm64_linux:   "663f7042e01ccd311df3a058121f3abdbc6892ad28aa1618b5ef9a6755670764"
    sha256 cellar: :any, x86_64_linux:  "55953064d40b61540b43433c8ebd8b785de3f62566a732090eb12b6e49319576"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "mongo-c-driver"

  def install
    # We want to avoid shims referencing in examples,
    # but we need to have examples/CMakeLists.txt file to make cmake happy
    pkgshare.install "examples"
    (buildpath / "examples/CMakeLists.txt").write ""

    mongo_c_prefix = formula_opt_prefix("mongo-c-driver")
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
    pkgconf_flags = shell_output("pkgconf --cflags --libs libbsoncxx1").chomp.split
    system ENV.cc, "-std=c++11", pkgshare/"examples/bsoncxx/builder_basic.cpp",
                   "-I#{pkgshare}", *pkgconf_flags, "-lstdc++", "-o", "test"
    system "./test"

    pkgconf_flags = shell_output("pkgconf --cflags --libs libbsoncxx1 libmongocxx1").chomp.split
    system ENV.cc, "-std=c++11", pkgshare/"examples/mongocxx/connect.cpp",
                   "-I#{pkgshare}", *pkgconf_flags, "-lstdc++", "-o", "test"
    assert_match "No suitable servers", shell_output("./test mongodb://0.0.0.0 2>&1", 1)
  end
end
