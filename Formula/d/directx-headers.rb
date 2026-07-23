class DirectxHeaders < Formula
  desc "Official DirectX headers available under an open source license"
  homepage "https://devblogs.microsoft.com/directx/"
  url "https://github.com/microsoft/DirectX-Headers/archive/refs/tags/v1.619.4.tar.gz"
  sha256 "427c4c20bdeb06022d706ba24cb14838b62cca4456a6072e826d7ffa706a4b1a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52f8a35aa4fa6fd15e70d4ceebbd7afb9980bf02f47e34ac9f4ce8a607edfc5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa175c2c8ecbca09051579bf7a2b2471c078b59fc8284642ca813214512e9a17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02f2f9bb07b014c34cc46120965fa6b371b99539cf4ca59a3d93249342fda8b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "947ec0ff6120716b048dc7eb59c2ab27430782353c8a4489ee9d1b4d4b023271"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df102ffbb0cd9bfbc1340b795ed557b8ef44248ad93318989272ff9495e78eef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "349b55c1f9e0e12331bb87412dacc6497c2db5a74e9a93cf1f3a3ff5a17998d6"
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
