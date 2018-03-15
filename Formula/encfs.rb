class Encfs < Formula
  desc "Encrypted pass-through FUSE file system"
  homepage "https://vgough.github.io/encfs/"
  url "https://github.com/vgough/encfs/archive/v1.9.4.tar.gz"
  sha256 "20656b4ead58ebd8d5f49a5c346b59e70dc2dc31220159e5b5a115bfa1bc40d6"
  head "https://github.com/vgough/encfs.git"

  bottle do
    sha256 "0c72ec1434ca15328e6f457cd597573e89ce6eec094cf32a81bf86e54179ddc8" => :high_sierra
    sha256 "e73cfe97ed8c56792ee5b8ed69b6edcad6de395b52b595b6b401146d88794f34" => :sierra
    sha256 "947383907b41cb5911c4d2f3b6f5b1a709bd7b049c0d296b0e2248de85673637" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gettext"
  depends_on "openssl"
  depends_on :osxfuse

  needs :cxx11

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    # Functional test violates sandboxing, so punt.
    # Issue #50602; upstream issue vgough/encfs#151
    assert_match version.to_s, shell_output("#{bin}/encfs 2>&1", 1)
  end
end
