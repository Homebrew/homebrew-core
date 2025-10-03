class DirectxHeaders < Formula
  desc "Official DirectX headers available under an open source license"
  homepage "https://devblogs.microsoft.com/directx/"
  url "https://github.com/microsoft/DirectX-Headers/archive/refs/tags/v1.618.1.tar.gz"
  sha256 "77f81abf03c07dffd4cc76762ff0c3ab465921a0aa0aaa25cdb294c8aaca4210"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81c1c06c25dbc2bb98b8864a0d1e0b6dd0811fa94835b557e699c08287691b78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caf0726807afbbe3c6aa93a7c28843ecb6f217f3feedefaf517d3397a20659b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d862b57e74db3af097bcb8b8849da309d5b3e1dffbb45e55677dfcd9f4201c6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "34062579ca759bf9f4120adecb52448a5871d7e8d285e9de3e30246521f63fc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6008afa273bf51920f09b7cb487647c9ef4d9e54829ca8e293eb793c6ad795df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61d5a8646d5ae2d9e4f2d11fd3438e5d314e5c0d84db18759dc62ee68e8e92a2"
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
