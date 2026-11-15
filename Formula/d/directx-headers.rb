class DirectxHeaders < Formula
  desc "Official DirectX headers available under an open source license"
  homepage "https://devblogs.microsoft.com/directx/"
  url "https://github.com/microsoft/DirectX-Headers/archive/refs/tags/v1.620.2.tar.gz"
  sha256 "2b916ef1be5db35313f56d60499274fed39db37b54a1f0befa8aa49041c14855"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ec41f95deb8169fcef40a02676bec9e6ab59a7a30d073c4299b9e5b456789fae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e00b2f5dd2346d2d84483aff9a58b8926d04b0bdaa44ec693d04bb6e182453e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2df2ad2dd4af8212d6c4adc5de2434adccd4333c8da4dfbca8fc30058b96343b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "599d990b2325335b828f57e7c635b105aabbfee53ad0ec196867a68eb8be5ee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "54f92c42ee20cc1f813e1b63ba24288d5152aab64333d17d8c7e28ba9eb55cfd"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "mingw-w64" => :test

  resource "test.cpp", :test do
    url "https://raw.githubusercontent.com/microsoft/DirectX-Headers/a7d19030b872967c4224607c454273a2e65a5ed4/test/test.cpp"
    sha256 "6ff077a364a5f0f96b675d21aa8f053711fbef75bfdb193b44cc10b8475e2294"
  end

  def install
    system "meson", "setup", "build", "-Dbuild-test=false", *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    resource("test.cpp").stage(testpath)

    ENV.remove_macosxsdk if OS.mac?

    system formula_opt_bin("mingw-w64")/"x86_64-w64-mingw32-g++", "-I#{include}", "-c", "test.cpp"
  end
end
