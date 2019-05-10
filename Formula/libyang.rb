class Libyang < Formula
  desc "YANG data modelling language parser, toolkit, and API written in C"
  homepage "https://github.com/CESNET/libyang"
  url "https://github.com/CESNET/libyang/", :using => :git, :tag => "v1.0-r2", :revision => "347246611b85e05d16f54faaa5697c4b2ee4b468"
  version "1.0-r2"
  sha256 "02b0131587cc677cbda1b153f9a9190e03e6143ee90252a68e5500b05e61170b"
  head "https://github.com/CESNET/libyang/"
  depends_on "cmake" => :build
  depends_on "pcre"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "true"
  end
end
