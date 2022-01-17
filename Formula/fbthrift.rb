class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.01.17.00.tar.gz"
  sha256 "15599efa59d87d63bcb672dea7ea24cf34102da6f68254368a442493843c985b"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "caaccb64c151209ec5485bb8bbddada1285f9e131f721813bdb545adfdf71f85"
    sha256 cellar: :any,                 arm64_big_sur:  "b00668a4eb4a02b2815f6c50db712915707bdd7100a64018266bff921385821e"
    sha256 cellar: :any,                 monterey:       "6bb4993e058108a0bc556034055c04c743e8be6e8f90dd30e5b7320e99a16b9e"
    sha256 cellar: :any,                 big_sur:        "97e5aace60d4bf26209e0d7fb8f9bc400cc70a57dd11e3582b2b1e49136ce1f7"
    sha256 cellar: :any,                 catalina:       "bd149abd6fed4e6c42bce1f42ebe63ba53b1c7316766f4e86596e39d8ff6de02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "081833b756b1822f9e867c54b8bd9a5afc20f63a038b13d9bc1a61ec5129840f"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@1.1"
  depends_on "wangle"
  depends_on "zstd"

  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc@10"
  end

  fails_with gcc: "5" # C++ 17
  fails_with gcc: "11" # https://github.com/facebook/folly#ubuntu-lts-centos-stream-fedora

  def install
    # The static libraries are a bit annoying to build. If modifying this formula
    # to include them, make sure `bin/thrift1` links with the dynamic libraries
    # instead of the static ones (e.g. `libcompiler_base`, `libcompiler_lib`, etc.)
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args, *shared_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    elisp.install "thrift/contrib/thrift.el"
    (share/"vim/vimfiles/syntax").install "thrift/contrib/thrift.vim"
  end

  test do
    (testpath/"example.thrift").write <<~EOS
      namespace cpp tamvm

      service ExampleService {
        i32 get_number(1:i32 number);
      }
    EOS

    system bin/"thrift1", "--gen", "mstch_cpp2", "example.thrift"
    assert_predicate testpath/"gen-cpp2", :exist?
    assert_predicate testpath/"gen-cpp2", :directory?
  end
end
