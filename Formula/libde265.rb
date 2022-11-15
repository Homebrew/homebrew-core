class Libde265 < Formula
  desc "Open h.265 video codec implementation"
  homepage "https://github.com/strukturag/libde265"
  url "https://github.com/strukturag/libde265/releases/download/v1.0.9/libde265-1.0.9.tar.gz"
  sha256 "29bc6b64bf658d81a4446a3f98e0e4636fd4fd3d971b072d440cef987d5439de"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e088b089bec796671d7a00c3d8aad4e2911efd0d649dcd72c15ee4cf97756e31"
    sha256 cellar: :any,                 arm64_monterey: "1e98138f0c8b39ef2d30ee5e27a2dfc67fd9c58585911517f9602e3e770c9ce7"
    sha256 cellar: :any,                 arm64_big_sur:  "448d589857e6ebac7a90f49e18cfc83ecf5c2bd45df346f8bbb85fe4f01103c4"
    sha256 cellar: :any,                 ventura:        "6b2f28d2584f4cc8e12a86524409ed48bed8c6354332f367f8b02020c55f9724"
    sha256 cellar: :any,                 monterey:       "2d258e7db5020ce6f359b4825b62b497de6e4a689bb0ad1502e46c49c8b139dc"
    sha256 cellar: :any,                 big_sur:        "f8af61259e67183de915096ab18424d2571c4dbafd1a029036933e604df4155c"
    sha256 cellar: :any,                 catalina:       "9e41b946c4c67a9f318415d18e0b00748d6bf8eec92977c0381e315e5fc94c83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a108482084ad30968aa38ef253df0a28e23e0b45a9feda60af2cc95fc8afc37"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    extra_args = []
    extra_args << "--build=aarch64-apple-darwin#{OS.kernel_version}" if Hardware::CPU.arm?

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
