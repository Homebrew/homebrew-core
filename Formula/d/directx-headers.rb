class DirectxHeaders < Formula
  desc "Official DirectX headers available under an open source license"
  homepage "https://devblogs.microsoft.com/directx/"
  url "https://github.com/microsoft/DirectX-Headers/archive/refs/tags/v1.619.1.tar.gz"
  sha256 "6193774904c940eebb9b0c51b816b93dd776cfeb25a951f0f4a58f22387e5008"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d7a71f9e4416bf63af6b7ed1c2c7dca98f34c6b0e1917e8926a0ae35b01692b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e1e0731354dba0d68e1f640c37340f20723cbded2bcbf4e6c16f399133c4791"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c56d31b978252ef14fd576b2dc8f38e15027f3e5f12454467e5e1ef297a544cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e283ac8535f3fb1c0ad04aff821ecac92f253d0c99e207b4f926ce2031326db4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bd9e83fbb2e810a14db26e48785dcfcc25fb541abf10c847635057c06b7c2a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f351534f4c948743491df1005f554a6518c89b8fd36b2b76d1c57c676356555"
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
