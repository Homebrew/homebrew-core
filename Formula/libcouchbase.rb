class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/current/sdk/c/start-using-sdk.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.8.5.tar.gz"
  sha256 "81a68bcac5dddeee85464cb0562771c03efd20d86f603351b6b4070339f2ec50"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "158f36843d4b437c00f8b20a13a3b1bf93229554bcf39c8f21d1063055596d1b" => :high_sierra
    sha256 "cf07ba33ba9cadabe808c26f92351f7b290127d9bb6e672cd1d341a89ee53dce" => :sierra
    sha256 "ffa6538645d711587723feeace3154d45080dbd2e32cab282d9e8d57af2d4a1d" => :el_capitan
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
