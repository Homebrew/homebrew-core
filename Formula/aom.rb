class Aom < Formula
  desc "Alliance for Open Media Codec SDK"
  homepage "http://aomedia.org"
  head "https://aomedia.googlesource.com/aom.git"

  depends_on "cmake" => :build
  depends_on "yasm" => :build

  devel do
    url "https://aomedia.googlesource.com/aom.git", revision: "00ce1fb2b38669d92d7a6c729e2ad39623c6e611"
    version "0.1.0"
  end

  def install
    mkdir "aom-build" do
      args = std_cmake_args
      args << ".."
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    system ./aomenc
    system ./aomdec
  end
end
