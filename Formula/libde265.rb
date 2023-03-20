class Libde265 < Formula
  desc "Open h.265 video codec implementation"
  homepage "https://github.com/strukturag/libde265"
  url "https://github.com/strukturag/libde265/releases/download/v1.0.11/libde265-1.0.11.tar.gz"
  sha256 "2f8f12cabbdb15e53532b7c1eb964d4e15d444db1be802505e6ac97a25035bab"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cd269b04f879cf736e59a4543a359f493baec4180570ab8a64ac980d1f5d8d75"
    sha256 cellar: :any,                 arm64_monterey: "ba6dd741ce35d7023354e6a01775fcfe59a05700c8ec3e28d9f27e2d9ec7fe9d"
    sha256 cellar: :any,                 arm64_big_sur:  "5ba1a106c989d9836f29a89ec3c83acbefe01a400f1e94fd2d34e054614c8815"
    sha256 cellar: :any,                 ventura:        "958ea9fe4735b4e09b99b416f229cc4d03f63ee0cd11d110f05cdd13d505528e"
    sha256 cellar: :any,                 monterey:       "e35e1196c5d748634db9327381c567d981768488b43bf144ed8707a8e305ed98"
    sha256 cellar: :any,                 big_sur:        "7c3afaff06376a54fde19c6e4615dcb18eb24b53a2f932e9286c2176e7ee06da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8385af5d9d6ee2d7c009ec98ffef6884abad83664fa31f3d631f80d597ef2573"
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
