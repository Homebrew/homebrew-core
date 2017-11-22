class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/4.5/sdk/c/start-using-sdk.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.8.3.tar.gz"
  sha256 "d4b33495c4cb974b135d052b712bd0253230caec008d27a94ba3def095e8db69"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "39c1dea296bc4124bb7b17ae7f39d342a1fdec8e4f879f7283764b687bd93a27" => :high_sierra
    sha256 "553933ce71e52501dc66d94aa33c66353a426a912aad3a14fec631850ff0ee6e" => :sierra
    sha256 "b3bc77ddc490667c8e6f9b547268559e6efea8fee145e0bff6f66932cb0e8b76" => :el_capitan
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
