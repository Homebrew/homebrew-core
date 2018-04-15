class Monero < Formula
  desc "Secure, private, untraceable cryptocurrency"
  homepage "https://getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      :tag => "v0.12.0.0",
      :revision => "c29890c2c03f7f24aa4970b3ebbfe2dbb95b24eb"

  bottle do
    sha256 "4605768a865c17daae09b3e1ddfd96babe0779126ff1ed90db26238e020d8283" => :high_sierra
    sha256 "8c2edbf826bcb23015e050ac072ff64d9d400ed0ef223b8fc53ddd14d4bb1335" => :sierra
    sha256 "6c4777177c56f4f1ef68393033421e0628a8c657cf4373ccbeb6c009c4b02430" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl"
  depends_on "readline"
  depends_on "zeromq"

  resource "cppzmq" do
    url "https://raw.githubusercontent.com/zeromq/cppzmq/7a8cc9d7cf448b8fd654ec4cd24fd48b57a76162/zmq.hpp"
    sha256 "eeccec908d78bc195d093fb05a37271b3f7a62ec65b026b6f0b8d801d9b966da"
  end

  def install
    resource("cppzmq").stage include.to_s

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
