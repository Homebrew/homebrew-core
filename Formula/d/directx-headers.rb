class DirectxHeaders < Formula
  desc "Official DirectX headers available under an open source license"
  homepage "https://devblogs.microsoft.com/directx/"
  url "https://github.com/microsoft/DirectX-Headers/archive/refs/tags/v1.620.1.tar.gz"
  sha256 "79cd6d5b87d940044b20a3f45e5fbf4a73e4c7eedc1bafabe1b5cabb97fef5bf"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "df985a8e398ab2eff82216f3398b198782a5872d9f7ee3c7e06a1573e5c1a844"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3a993ad2876bd75505e5c898932fa5e8bc24b5fa40345c29aadecf97d45837ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d8da6b81e074e277d2ecd8d648851b0c6bbda92f04296fd957651ee49b479560"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1d9e99a6a11157107649ea1950c0680303a8f9e07ae482a9c417f8ed71b6b3cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "55e5d1cb9d19e8ff3398520b70c9ccc0117c3f46a7622a4659548e16d3fb446d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "mingw-w64" => :test

  resource "test.cpp", :test do
    url "https://raw.githubusercontent.com/microsoft/DirectX-Headers/a7d19030b872967c4224607c454273a2e65a5ed4/test/test.cpp"
    sha256 "6ff077a364a5f0f96b675d21aa8f053711fbef75bfdb193b44cc10b8475e2294"
  end

  # Add missing SAL annotations to the non-Windows stubs
  patch do
    url "https://github.com/microsoft/DirectX-Headers/commit/d0b4f7936049872552249707a149dc2837ac03ef.patch?full_index=1"
    sha256 "9beaeda49cc1fae1a0b9f43a2b2d5be8d517184a1635b3bde7cc4d808cc36ae8"
    type :backport
    resolves "https://github.com/microsoft/DirectX-Headers/issues/295"
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
