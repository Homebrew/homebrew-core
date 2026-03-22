class Cmockery < Formula
  desc "Unit testing and mocking library for C"
  homepage "https://github.com/google/cmockery"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/cmockery/cmockery-0.1.2.tar.gz"
  sha256 "b9e04bfbeb45ceee9b6107aa5db671c53683a992082ed2828295e83dc84a8486"
  # Installed COPYING is BSD-3-Clause but source code uses Apache-2.0.
  # TODO: Change license to Apache-2.0 on next version as COPYING was replaced by LICENSE.txt
  license all_of: ["BSD-3-Clause", "Apache-2.0"]

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "8c4679ab8e8779a11746c1d18156b83b3446ff6d332b06e6548585b84fc51101"
    sha256 cellar: :any,                 arm64_sonoma:   "96b7a50e99334762c47dbc4bb42797533aca4aa0141ec6f424f507a292bd69a4"
    sha256 cellar: :any,                 arm64_ventura:  "0f6c19c77f86e9f39f372d29d58e853214b1b6b3fcf20f6373caac86703c2279"
    sha256 cellar: :any,                 arm64_monterey: "9e210bb4657cf606373fa730ab8b6d7d730fd98d61b1d5d0b06f81221e33b3c9"
    sha256 cellar: :any,                 sonoma:         "4131cb44e21e3d538d40dfe05a22e74ecb606f6d62824033a16f8c16500425a7"
    sha256 cellar: :any,                 ventura:        "794e2b0c95e15b2afdfb0c4d2a2cd958a44010ca8af935106859f12d12d2c505"
    sha256 cellar: :any,                 monterey:       "cfab88dcbb19db85f57560657a7658e4eb6353ca0ca104ffa27b78c4bf877b95"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bc649e007cdf15b3e39dd4c06b20e7910c4732b09e67a13c18c567fad0f9e444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55dae4a89d4badbbe3628527d765ac03feb8a344607af7ddf7b7d6396cf78a29"
  end

  # see thread, https://github.com/google/cmockery/issues/72
  deprecate! date: "2024-07-07", because: :unmaintained
  disable! date: "2025-07-07", because: :unmaintained

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # This patch will be integrated upstream in 0.1.3, this is due to malloc.h being already in stdlib on OSX
  # It is safe to remove it on the next version
  # More info on https://code.google.com/p/cmockery/issues/detail?id=3
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/cmockery/0.1.2.patch"
    sha256 "4e1ba6ac1ee11350b7608b1ecd777c6b491d952538bc1b92d4ed407669ec712d"
  end

  def install
    # workaround for Xcode 14.3
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    # Fix -flat_namespace being used on Big Sur and later.
    # Need to regenerate configure since existing patches don't apply.
    system "autoreconf", "--force", "--install", "--verbose" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end
end
