class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.2.3.tar.gz"
  sha256 "b131867c9b8db69fe8709b430ae95f989796c1279004617cbbc741dde461dacb"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 arm64_monterey: "b866f2edb54f3b20cca64adc565ce7bc4a71f871d14e917b9bb59ebd39c4158a"
    sha256 arm64_big_sur:  "b34f3cc0a623995a4030e8013029aa9e5ffc550bf6548da3c6498fc598243284"
    sha256 monterey:       "ba4296240fb178e72b43b3073608e689f1893f14e3b664369e3672c4621d809b"
    sha256 big_sur:        "4612c9639e2f6438b631b40f72fb7a005de0381266698ef617cfc98cc5113ebb"
    sha256 catalina:       "849c52aec8ef236bbcbea83e3eb6d12773124beecc51344c63424da7e0a579c7"
    sha256 mojave:         "2dd828a51b990553186fd1bcdd26dd7f7367e02a6eeb092e6f1ef8db134ef845"
    sha256 x86_64_linux:   "e2d7602e6338db5a0b576566693972e3abd616d65079f8d751076653653ce651"
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
