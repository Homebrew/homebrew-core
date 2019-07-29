class Geographiclib < Formula
  desc "C++ geography library"
  homepage "https://geographiclib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.49.tar.gz"
  sha256 "aec0ab52b6b9c9445d9d0a77e3af52257e21d6e74e94d8c2cb8fa6f11815ee2b"

  bottle do
    cellar :any
    sha256 "a97fd12c98b8aa7d6bb7187a7bcb87a5728cbc8d09cdfbec8a890a50539ba02a" => :mojave
    sha256 "69f55b7d549bf61aa3867cd5451a3df11ca71f823c5baef79631ed9edfc32417" => :high_sierra
    sha256 "d583748cacffdef26dca690a0f8e87d02166ce7ef1907e9bbf282f7e0c099b1c" => :sierra
    sha256 "a730f21ffa4e9503f15d8b3ecd51c846cac5e79581ef5ec86297c4c10739e4a3" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"GeoConvert", "-p", "-3", "-m", "--input-string", "33.3 44.4"
  end
end
