class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/4.5/sdk/c/start-using-sdk.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.8.1.tar.gz"
  sha256 "b48c72b5c407ae0f31ec0634b2d31c3e034f1fcec58c60dd14b711ddca55d214"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "5ec8d3eb6d3363bccbc4e314fc26fdfa6bbb134d7935aa70a1fecb7f3f119c59" => :high_sierra
    sha256 "9371839c4f7756e6ee7bea6f4bffbdbb246be66262cb7ed5a8854fcf91b39020" => :sierra
    sha256 "ad3b2e9a39ba095edff470175371092fc3d990a1d5bafc8f376c5604cd80af16" => :el_capitan
    sha256 "7d29ae128f2b10a187efc54b0db42f921c8d0ed63999e375618d7626a529af75" => :yosemite
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
