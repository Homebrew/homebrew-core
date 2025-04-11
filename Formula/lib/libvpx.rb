class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "6cba661b22a552bad729bd2b52df5f0d57d14b9789219d46d38f73c821d3a990"
  license "BSD-3-Clause"
  head "https://chromium.googlesource.com/webm/libvpx.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5b72c6376740d6c702c7bb1bca4292b9cb09b6aca7b16bcf01d5d2cccbaf7b7a"
    sha256 cellar: :any,                 arm64_sonoma:  "1a57c51283a0015aeab14dd14210f47beeb270321a85f5c5d3bddfc34c15b000"
    sha256 cellar: :any,                 arm64_ventura: "68b0b266de2faa807df3dcd3c85e0028c8c12c93d22874c0c2676575101a3362"
    sha256 cellar: :any,                 sonoma:        "823e82b27cf734c2a64525934a6909e3c07e09e0cb75a398afc2fbc66be0af78"
    sha256 cellar: :any,                 ventura:       "bfe84c4076b989468d359f0ebf2f46ad601da3383e6d50719accc374346b6853"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbb0de3aebd92b66a9ba25ef5cac9b8f0419599e434fea7b5d4dd31de104278b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a56173a7f792054fab125d92e8d5441329041b09bb26d1ee6e69efd3bac77df"
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
