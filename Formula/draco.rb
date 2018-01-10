class Draco < Formula
  desc "Draco is a library for compressing and decompressing 3D geometric meshes and point clouds. It is intended to improve the storage and transmission of 3D graphics."
  homepage "https://google.github.io/draco/"
  url "https://github.com/google/draco/archive/1.2.4.tar.gz"
  sha256 "993c78880f4bbd2bfbc7b1e16809c2f62f8ecf9040f68db75ca65be3ac34be4f"

  depends_on "cmake" => :build

  def install
    mkdir "build" do
    args = std_cmake_args
    system "cmake", "..", *args
    system "make", "install"
    end

  end

end
