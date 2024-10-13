class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.3.13.tar.gz"
  sha256 "51de483251a84696ac2793ad9a805d563e214efed2161ea6d26285192c1832a6"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git", branch: "master"

  # github_releases is used here as there have been tags pushed for new
  # releases but without a corresponding GitHub release
  livecheck do
    url :head
    regex(/^?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 arm64_sequoia: "a4b121b14d4bbb9ed0843f55797fb96e13e825d0b7d1e762485da68515b8d323"
    sha256 arm64_sonoma:  "f527bb3b8f45c11369c13d572025303db9412bc2a4039d9593b08f27c3a7cf45"
    sha256 arm64_ventura: "30ca320a61fea75b2e08d0c311af69677f71bf4fb08d66ec18070aaa30480e0d"
    sha256 sonoma:        "b9fff3514c8f63ec2813ca4d373bade1dd81282000585d977b5b5ff1268b2b9e"
    sha256 ventura:       "103a2b962f8152293a16429a055e675b942e007e83bee40b3af75d67ff471e7f"
    sha256 x86_64_linux:  "8f0b1e56054e0881d7022398b8ad8e827fbcfe764578d78e2951f07179585b46"
  end

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@3"

  conflicts_with "cbc", because: "both install `cbc` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DLCB_NO_TESTS=1",
                    "-DLCB_BUILD_LIBEVENT=ON",
                    "-DLCB_BUILD_LIBEV=ON",
                    "-DLCB_BUILD_LIBUV=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "LCB_ERR_CONNECTION_REFUSED",
      shell_output("#{bin}/cbc cat document_id -U couchbase://localhost:1 2>&1", 1).strip
  end
end
