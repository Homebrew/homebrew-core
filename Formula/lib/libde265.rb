class Libde265 < Formula
  desc "Open h.265 video codec implementation"
  homepage "https://github.com/strukturag/libde265"
  url "https://github.com/strukturag/libde265/releases/download/v1.0.15/libde265-1.0.15.tar.gz"
  sha256 "00251986c29d34d3af7117ed05874950c875dd9292d016be29d3b3762666511d"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "346e295e45642678397ce9a2c2fe35866ad9de3a25fe0f2415e23820c9014f22"
    sha256 cellar: :any,                 arm64_ventura:  "d7bbd6c1737158e09bc6f293e030960d6e0b12752eb3af054d47049e6c6c9826"
    sha256 cellar: :any,                 arm64_monterey: "f20e502014e0a1fb4904865911ec1dceee372b88d53e805179e794c16f804014"
    sha256 cellar: :any,                 sonoma:         "baa8684dbb6aa00aac5a0b9b4d3e670df8cbd4d0c6635e03f175a1df2a20c5fa"
    sha256 cellar: :any,                 ventura:        "813eaa5be8c6631bd98eaf6d75dabc83ba8873307bd48aee4b1d997bfcd14cc8"
    sha256 cellar: :any,                 monterey:       "565b815761c1a929264957ebbb1ee5b0fc1e411080268715f304e9511f2989a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ef37dfca2d2c3566656d50015d8a4d6a8247645f471d63f5d15796716e54f86"
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
