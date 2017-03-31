class Fast < Formula
  desc "Flattening Abstract Syntax Trees"
  homepage "https://github.com/yijunyu/fast"
  url "https://github.com/yijunyu/fast/archive/v0.0.1.tar.gz"
  version "0.0.2"
  sha256 "844467051325cee43ba98b52e9512133ec53388153b32339190509b82570a4e9"

  depends_on "cmake" => :build
  depends_on "flatbuffers" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on "srcml" => :optional

  def install
    system "cmake", "-G", "Unix Makefiles", *std_cmake_args
    system "make", "install"
  end

  test do
    system "true"
  end
end
