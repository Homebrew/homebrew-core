class DirectxHeaders < Formula
  desc "Official DirectX headers available under an open source license"
  homepage "https://devblogs.microsoft.com/directx/"
  url "https://github.com/microsoft/DirectX-Headers/archive/refs/tags/v1.615.0.tar.gz"
  sha256 "5394360b517f431949d751f3bcb4150313f28815aded514531c7aaea81bac314"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1faa5858f89b77c2dd492a5ccd6cda74370dc6d2c7d0bcfe840f9282aefa628a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "595d10c58c4361c6a1295b3d3dff7138eb77d700c0cd4c0d97b548df7dfc927d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2fc37a89a3f7d4bf06a790889419a85f6c3f8779bdb808c02d5b43580df8f0aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb29c4055384634a995682654a7baeb1fa06765e05302fc6f0379edf7dcac747"
    sha256 cellar: :any_skip_relocation, ventura:       "0774047098f7cf7b6ecb92bdd8276aef0e5c992b9985e6e29cac3109832c8e29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6de4f60ee0cd679353d3089b80fd89a62fdd1df0f51b9b5c3cf32526dc95e246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5e786b1e03793996fac1da7d9a4b8c0a55090212b67c6b054ba508892a22b02"
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
