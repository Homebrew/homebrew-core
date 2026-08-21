class DirectxHeaders < Formula
  desc "Official DirectX headers available under an open source license"
  homepage "https://devblogs.microsoft.com/directx/"
  url "https://github.com/microsoft/DirectX-Headers/archive/refs/tags/v1.619.5.tar.gz"
  sha256 "24a0b7d8079a2dbbc90753c0d8bc812040d052acce2302e69a97c5d873b313b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd5e7e8ebf3d3bf84450a894a95b3ca913758f95b2c1796e8c76deb1175d3244"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2888a9116bc867c66ad9d94c0d149b7ec21b164b45bf38f80282eed478dc3a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19703e065ce0876e7125e87b01d48f5c18879e1fd6f603861320b05a5b0a3835"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4b8cdf65fb30e94650cf13b10db7a09296b32bf11e7d56487177a3a1adae875"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "028b2b9cca85001727eaf6540f39f1ebb7a11a1b4dc4f2ff5056551ad5a51fe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8024298a47d80c9902f458d2d26e38fad7ed4f1132d0317e9f9c850f417c796"
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
