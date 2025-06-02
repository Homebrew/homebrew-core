class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "6cba661b22a552bad729bd2b52df5f0d57d14b9789219d46d38f73c821d3a990"
  license "BSD-3-Clause"
  head "https://chromium.googlesource.com/webm/libvpx.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bb811f6f020d8bc6925bbc2c7fd83b1c0af249771c569ffaff2b7615d3401b45"
    sha256 cellar: :any,                 arm64_sonoma:  "bb7841386f01932b9462487ebf797f5bdc33ef60ab25d03f9713a415f4ae5ee8"
    sha256 cellar: :any,                 arm64_ventura: "c071523e335390cfb3a53a31605370e59661ceb34d3de70ce5c994f5fa266176"
    sha256 cellar: :any,                 sonoma:        "6e42222126ae6f4972a445ca86c025c757e821b968d0cfe27ae50872bcdc0778"
    sha256 cellar: :any,                 ventura:       "35cbc1468a09a60c41864e771f22fb9bcfd95d28e3562424ed96dd4729f3e4dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "883ccf021a6b372db93238b4e761933605d6f502760912bac8c3816f7488fa85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42acfc38372a660e6db58db33af8a0700fdaecbd1775244cbe40941d7d3cb210"
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
