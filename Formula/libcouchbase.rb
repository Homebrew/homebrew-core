class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/current/sdk/c/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-2.9.0.tar.gz"
  sha256 "ef2255b867523d19eb0e9f3f5d0c943e67cca3609ab60a55193243694bec8069"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "5845edf5034a5e20d86a926bc506a0c52e2ec7b04de7b4258382dc3715b4d610" => :high_sierra
    sha256 "48be64c2a44e6fe7b7452547d797be53b3474796bab4d7288f038963b64647bc" => :sierra
    sha256 "8f97755e01028c48c98ca2a080d659f36aa834f8dcf13616434ea504b5b5bb4c" => :el_capitan
  end

  option "with-libev", "Build libev plugin"

  deprecated_option "with-libev-plugin" => "with-libev"

  depends_on "libev" => :optional
  depends_on "libuv" => :optional
  depends_on "libevent"
  depends_on "openssl"
  depends_on "cmake" => :build

  def install
    args = std_cmake_args << "-DLCB_NO_TESTS=1" << "-DLCB_BUILD_LIBEVENT=ON"

    ["libev", "libuv"].each do |dep|
      args << "-DLCB_BUILD_#{dep.upcase}=" + (build.with?(dep) ? "ON" : "OFF")
    end

    mkdir "LCB-BUILD" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/cbc", "version"
  end
end
