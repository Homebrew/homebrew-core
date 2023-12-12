class Fbx2gltf < Formula
  desc "CLI for converting FBX files to glTF files"
  homepage "https://github.com/godotengine/FBX2glTF"
  url "https://github.com/godotengine/FBX2glTF/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "dd99d2ef4c84a23898ab23f32e6eeca2c8cbc0ce98f0747a2e229fd49b2dfbdf"
  license "BSD-3-Clause"

  depends_on "cmake" => :build
  depends_on "conan@1" => :build
  depends_on arch: :x86_64

  resource "fbxsdk" do
    url "https://github.com/V-Sekai/FBXSDK-Darwin/archive/refs/tags/2020.2.tar.gz"
    sha256 "6a407903ac5144bd2d53ed3b8a45933eb36b7186b176657e4ae8effef44ee10c"
  end

  def install
    system "conan", "profile", "new", "default", "--detect"
    system "conan", "profile", "show", "default"
    resource("fbxsdk").stage { buildpath.install "sdk" }
    ENV["CMAKE_OSX_ARCHITECTURES"] = "x86_64"
    system "conan", "install", ".", "-i", "build", "-s", "build_type=Release", "--settings", "arch=x86_64",
        "--build", "missing"
    system "conan", "build", "-bf", "build", "."
    bin.install "sdk/Darwin/2020.2/License.rtf" => "FBX-SDK-License.rtf"
    bin.install "LICENSE" => "FBX2glTF-License.txt"
    bin.install "build/FBX2glTF" => "FBX2glTF-macos-x86_64"
  end

  test do
    system bin/"FBX2glTF-macos-x86_64", "--help"
  end
end
