class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.3.5.tar.gz"
  sha256 "75bf6770b1a98289bbc079c302fe40286f2e7003aaffe64403fe04aaa84e0fc1"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "d9214a7dee5702813a29b54eb1609161e4caf74cdfc426bfc4453c9e9a2853be"
    sha256 arm64_monterey: "ccc61af9bf33de16f1ae67f25a8313e08f72a4e0f8e6ea05335edbe608713342"
    sha256 arm64_big_sur:  "bbbc7d284801bb8a6acedc11155bea2aab94c6acc1866316b0001e59a80adbd9"
    sha256 ventura:        "45d30cd6b52d62085175dc4a33f03d8be1be318402d6391bbc2b579fdc2354d5"
    sha256 monterey:       "32d83fdc521c2d5965c7aadecd775fcc1f46c51e8feb81b2b9678574f3128c89"
    sha256 big_sur:        "01e9b91accbed749daf98ec9bad32799b384e765a4b999ac6316f77de824d523"
    sha256 x86_64_linux:   "f6bae5e18d79df4e6270fbd5b716eeee92adedc08d5ac74118b8c2c815ad307f"
  end

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DLCB_NO_TESTS=1",
                            "-DLCB_BUILD_LIBEVENT=ON",
                            "-DLCB_BUILD_LIBEV=ON",
                            "-DLCB_BUILD_LIBUV=ON"
      system "make", "install"
    end
  end

  test do
    assert_match "LCB_ERR_CONNECTION_REFUSED",
      shell_output("#{bin}/cbc cat document_id -U couchbase://localhost:1 2>&1", 1).strip
  end
end
