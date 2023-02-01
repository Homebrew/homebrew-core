class Libde265 < Formula
  desc "Open h.265 video codec implementation"
  homepage "https://github.com/strukturag/libde265"
  url "https://github.com/strukturag/libde265/releases/download/v1.0.11/libde265-1.0.11.tar.gz"
  sha256 "2f8f12cabbdb15e53532b7c1eb964d4e15d444db1be802505e6ac97a25035bab"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "62257cc326efdd4b9055b61396bb1aa9136e7b66888404d9b7fa066f6b3aa21a"
    sha256 cellar: :any,                 arm64_monterey: "6676c2535237dcb4eb457f0ddb23125b87218e0e137dc34aa1b66920cc6fe40a"
    sha256 cellar: :any,                 arm64_big_sur:  "d9f44ac3ef31fffc8d704e278f02f3fc7a00cc6296c107646f2092343e4f115e"
    sha256 cellar: :any,                 ventura:        "d5f56cf35f972702c4cc6d0e837a83b62fcb84b42e55fb4a415b678a1a18f7d0"
    sha256 cellar: :any,                 monterey:       "a282a833e315a4be5f9e52cbc726a12113c49f0a5dd8ac699e7fd18e2e8d3616"
    sha256 cellar: :any,                 big_sur:        "f94a2c35bdcda702dffbbbf3f885d0fe2e5e8ba51423cdd55444980b735723f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1951618266922aa0d517ffa63ab1787a45802bf6b1058607a5219d0f88491e77"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    extra_args = []
    extra_args << "--build=aarch64-apple-darwin#{OS.kernel_version}" if OS.mac? && Hardware::CPU.arm?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-sherlock265",
                          "--disable-dec265",
                          "--prefix=#{prefix}",
                          *extra_args
    system "make", "install"

    # Install the test-related executables in libexec.
    (libexec/"bin").install bin/"acceleration_speed",
                            bin/"block-rate-estim",
                            bin/"tests"
  end

  test do
    system libexec/"bin/tests"
  end
end
