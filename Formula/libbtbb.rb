class Libbtbb < Formula
  include Language::Python::Shebang

  desc "Bluetooth baseband decoding library"
  homepage "https://github.com/greatscottgadgets/libbtbb"
  url "https://github.com/greatscottgadgets/libbtbb/archive/2020-12-R1.tar.gz"
  version "2020-12-R1"
  sha256 "9478bb51a38222921b5b1d7accce86acd98ed37dbccb068b38d60efa64c5231f"
  license "GPL-2.0-or-later"
  head "https://github.com/greatscottgadgets/libbtbb.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f629f048ad92f8a52a8d12f6defe50d6c01c7cac434e26fbf3ee80f52f40c2d4"
    sha256 cellar: :any,                 arm64_big_sur:  "3f24dbcd8136188fe1ae8d8ff41dc5f228674b25bd0b4cd81c37a5e67528212d"
    sha256 cellar: :any,                 monterey:       "1c04db96b086f676caccb396b2fb2831bc207914861847615c224be051407966"
    sha256 cellar: :any,                 big_sur:        "49bf40e0711721bffda654f8d1bb61912cb130b64dcee74d05918a70079d5caa"
    sha256 cellar: :any,                 catalina:       "eaed5fcee578de521f01fca38fa0975b5c0f56a80f9391840bd7f815550d9f75"
    sha256 cellar: :any,                 mojave:         "8378b76f21bc170c9def4e0fab0d7af8caaccb1afe4fd59e6e9fc3a1cd549c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85cfb3e1de889506ec89c584a3f11c013bd9699cc8c2cb3bdb321a82c5e6611c"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    rewrite_shebang detected_python_shebang, bin/"btaptap"
  end

  test do
    system bin/"btaptap", "-r", test_fixtures("test.pcap")
  end
end
