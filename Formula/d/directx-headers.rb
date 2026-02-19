class DirectxHeaders < Formula
  desc "Official DirectX headers available under an open source license"
  homepage "https://devblogs.microsoft.com/directx/"
  url "https://github.com/microsoft/DirectX-Headers/archive/refs/tags/v1.618.2.tar.gz"
  sha256 "62004f45e2ab00cbb5c7f03c47262632c22fbce0a237383fc458d9324c44cf36"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3c57c3ddbad669a195eea6cad3f154be704a12b63273d389b21ccd687bf0936"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b9f8af56620ed8e01e583ff79d21fcffb85c8a0734e4b41bb1d1e3d377bacaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b41f82cd50733cec1f3664747501b40d632ef657f62d849943e49699fbe264f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "88f4a31d82896f56c9a2b16cded6bee0efb76cf66f2ab4ce5f1662bd0c652915"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c85e5b126134c36c124d6ca195ccf6cb846cf7c5d6faff623d6c6b903bda7393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ec5332819c79bc05557054b05aefa21468731551a75588df9efa10cb2d2692a"
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

    system Formula["mingw-w64"].bin/"x86_64-w64-mingw32-g++", "-I#{include}", "-c", "test.cpp"
  end
end
