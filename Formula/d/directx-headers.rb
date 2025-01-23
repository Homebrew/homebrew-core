class DirectxHeaders < Formula
  desc "Official DirectX headers available under an open source license"
  homepage "https://devblogs.microsoft.com/directx/"
  url "https://github.com/microsoft/DirectX-Headers/archive/refs/tags/v1.614.1.tar.gz"
  sha256 "344eb454c979ea68d8255d82c818bf7daf01f5109d26ac104f9911d18fae3b21"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "425dc8307b005fcdae3f4ee34b4fa49564f854f52e8c0b805373b4b4002a0fe0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb1a83cc01fc2c78a1422bd073a8c357da3d2543999ccd12aff794be388781b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60fe0d75c86a6321516e637d944353de30910b55f5d9c7705fac6c10adf21a8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8627e2ba3571850de43a8a5b64b92e216e949182ffb7957fe42a45d77e554485"
    sha256 cellar: :any_skip_relocation, ventura:       "afc9d01669eef5d85fb9e6c7fc2a031285032afbc78ded8d1dd919169fbaad46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68c8d1889f90e8f07a83f180649955413e2684fdb8e10f8c2f92e1a7d4c680a3"
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
