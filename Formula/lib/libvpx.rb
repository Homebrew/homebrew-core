class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "7a479a3c66b9f5d5542a4c6a1b7d3768a983b1e5c14c60a9396edc9b649e015c"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://chromium.googlesource.com/webm/libvpx.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "38d28c66d270e2d9b1826f16ec4721b6532a1c59c9ace22811cca3aac43b06ab"
    sha256 cellar: :any,                 arm64_sequoia: "4f72f10109e23239ba65d4e7c1eb9086a4b2cd2875f784c8f9d79d713106675d"
    sha256 cellar: :any,                 arm64_sonoma:  "dbc1b002c52c40ae7d892801b81be82cc1666cd7952273037efc8027a5126eba"
    sha256 cellar: :any,                 sonoma:        "198eadc026da61065d4f3c626c89bdc770c9109311e0b59db4f5ab0487345dea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecd53d77a7fa7af9ae5878f5f52483be94eb6ea08264059fcc59707909c41dcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "980eac19f80348cc5e5f27f06410a3d724b86727ec6f128355c7ee1dd4b3b09d"
  end

  on_intel do
    depends_on "yasm" => :build
  end

  def install
    ENV.runtime_cpu_detection
    # NOTE: `libvpx` will fail to build on new macOS versions before the
    # `configure` and `build/make/configure.sh` files are updated to support
    # the new target (e.g., `arm64-darwin24-gcc` for macOS 15). We [temporarily]
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
      --enable-runtime-cpu-detect
      --enable-shared
      --enable-vp9-highbitdepth
    ]
    args << "--target=#{Hardware::CPU.arch}-darwin#{OS.kernel_version.major}-gcc" if OS.mac?

    mkdir "macbuild" do
      system "../configure", *args
      system "make", "install"
    end
  end

  test do
    system "ar", "-x", "#{lib}/libvpx.a"
  end
end
