class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "5f21d2db27071c8a46f1725928a10227ae45c5cd1cad3727e4aafbe476e321fa"
  license "BSD-3-Clause"
  head "https://chromium.googlesource.com/webm/libvpx.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "484698903af5db7c9b7d6b4e5791f702ae99a9167a0119773b30d1c9b34ffdba"
    sha256 cellar: :any,                 arm64_ventura:  "6a40c8dea8edfd2ebf1aec9894b91239691651bd92f6d2e61f3ffa0b9e79fe6e"
    sha256 cellar: :any,                 arm64_monterey: "74b80630744e3c8f51c8b40089a2b07529d1a319f03b67cf387e914e52b80d83"
    sha256 cellar: :any,                 sonoma:         "20b5db6c221c97a82f9808bee54a4467f36c761d3c9effa5ee706c81b83da97c"
    sha256 cellar: :any,                 ventura:        "4225649fc700b5974f0fe3b01a6642e93a7669f9d2525b2344b4535d02cd2970"
    sha256 cellar: :any,                 monterey:       "3ad4e913a0955ebcbb0c5760d9dfbd3add260bd5932e61b9e9f996014e3a2a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a251c029dbfab1d5545b5b07c80f317b3860cca7ed32a18b91f4e6076348ab1"
  end

  on_intel do
    depends_on "yasm" => :build
  end

  def install
    # NOTE: `libvpx` will fail to build on new macOS versions before the
    # `configure` and `build/make/configure.sh` files are updated to support
    # the new target (e.g., `arm64-darwin23-gcc` for macOS 14). We [temporarily]
    # patch these files to add the new target (until there is a new version).
    # If we don't want to create a patch each year, we can consider using
    # `--force-target=#{Hardware::CPU.arch}-darwin#{OS.kernel_version.major}-gcc`
    # to force the target instead.
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-examples
      --disable-unit-tests
      --enable-pic
      --enable-shared
      --enable-vp9-highbitdepth
    ]
    args << "--target=#{Hardware::CPU.arch}-darwin#{OS.kernel_version.major}-gcc" if OS.mac?

    if Hardware::CPU.intel?
      ENV.runtime_cpu_detection
      args << "--enable-runtime-cpu-detect"
    end

    mkdir "macbuild" do
      system "../configure", *args
      system "make", "install"
    end
  end

  test do
    system "ar", "-x", "#{lib}/libvpx.a"
  end
end
