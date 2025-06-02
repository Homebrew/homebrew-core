class DirectxHeaders < Formula
  desc "Official DirectX headers available under an open source license"
  homepage "https://devblogs.microsoft.com/directx/"
  url "https://github.com/microsoft/DirectX-Headers/archive/refs/tags/v1.616.0.tar.gz"
  sha256 "125f492802939b40223bfccb83badd3f599af2d3449613d6cb893720607b9025"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb5c5ae2b6de234816a184a62ec9d12d243afc8bd1534b75a86170fae18c72a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7dc221c2bb1cf739f8f4bd9868e18474022926456a28f5a813088882e511659"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d5a6058f427316afd3395751e19c4b35cca15a8be143c87638d551560228c22"
    sha256 cellar: :any_skip_relocation, sonoma:        "5513dbb2d1308ab53cf7f961029d78cd5d356d975b9df585dc530393bd4eea58"
    sha256 cellar: :any_skip_relocation, ventura:       "a45e4983d2abd2a93c2f5d95b8381b0c1716f61566a191f6a9d93d3f70554f56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "472a6f4261fe6187ceb663bee50f9468dae7e72b08cda2f1d8d9837a7cc6fbf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77a64f9183afa9c7d541d27c99ccf383ce17517e2fd5cdd3eb8594250ec8cf1e"
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
