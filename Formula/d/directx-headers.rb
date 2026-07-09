class DirectxHeaders < Formula
  desc "Official DirectX headers available under an open source license"
  homepage "https://devblogs.microsoft.com/directx/"
  url "https://github.com/microsoft/DirectX-Headers/archive/refs/tags/v1.721.2.tar.gz"
  sha256 "b736c311057f2b426eb465d4e7867da4eb4e76d69be27f45bfa359189f97c0b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3769c9555c5d1e815ece045baac0b8b802e3605bb071f26cd45ef4c4ab4e1102"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccfbfc1eec8d6ca7634750882126eef71899dae3d04cae31a7c2d586d9781e8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "811616de5c8b8a564ba9f1c29358053018f7a20f626601a4668f69c1bf4e1665"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b9e3b1a7bfcf2d1a870c9e49427920d64f1816238c421c149c553dfe8d275c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "719a259511f2717281c2f35fa65f727e7a60efe2c964e6d1db473d923c768996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9fed14c646671f7734b52a06a7b304abc93782b4a9c3a77e67270ae674e908d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "mingw-w64" => :test

  def install
    system "meson", "setup", "build", "-Dbuild-test=false", *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    resource "test.cpp" do
      url "https://raw.githubusercontent.com/microsoft/DirectX-Headers/a7d19030b872967c4224607c454273a2e65a5ed4/test/test.cpp"
      sha256 "6ff077a364a5f0f96b675d21aa8f053711fbef75bfdb193b44cc10b8475e2294"
    end

    resource("test.cpp").stage(testpath)

    ENV.remove_macosxsdk if OS.mac?

    # State object database helper needs MSVC ATL and HRESULTs unavailable in mingw-w64
    system Formula["mingw-w64"].bin/"x86_64-w64-mingw32-g++", "-I#{include}",
           "-DD3DX12_NO_STATE_OBJECT_DATABASE_HELPERS", "-c", "test.cpp"
  end
end
