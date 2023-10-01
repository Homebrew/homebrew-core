class Libde265 < Formula
  desc "Open h.265 video codec implementation"
  homepage "https://github.com/strukturag/libde265"
  url "https://github.com/strukturag/libde265/releases/download/v1.0.12/libde265-1.0.12.tar.gz"
  sha256 "62185ea2182e68cf68bba20cc6eb4c287407b509cf0a827d7ddb75614db77b5c"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "66d79ae49de8c7cc7d67359814d4e2979ad57c0e306fd4d24f13af8e6134847b"
    sha256 cellar: :any,                 arm64_ventura:  "26fbc47de1c2def0af2074c49d65e3b478d575845202ba56106a3706dadf017f"
    sha256 cellar: :any,                 arm64_monterey: "67fd9382d2162c9b8924afcbc0df2481f9525434755a909313e83f3745fbbbc9"
    sha256 cellar: :any,                 arm64_big_sur:  "6bfe50bccf4abeed8e44f23f3d0099db343d04995c4b52644f7d401abf0bb3b2"
    sha256 cellar: :any,                 sonoma:         "bd5e5b227faf3dcde67a38efe63cb860dd6ed9bdcbed2bfe5016083550046d46"
    sha256 cellar: :any,                 ventura:        "76a2d1732926d1da6abab3c352f5198ee71eb3cae3dcebcc70952821480c1e28"
    sha256 cellar: :any,                 monterey:       "21aa7217dd412146a7855cdf6d8221946f727921a925cb1a521211d9ac8bf9e2"
    sha256 cellar: :any,                 big_sur:        "af1c29ef42925e64e1f5d7ca7edde8561f3a78ecfd3f89d6c6443bb7f0e41088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9667a3c2c114204dd0061c35e8c1d60a28d201fdb62b8d30476ab5770046070"
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
