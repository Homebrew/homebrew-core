class Libde265 < Formula
  desc "Open h.265 video codec implementation"
  homepage "https://github.com/strukturag/libde265"
  url "https://github.com/strukturag/libde265/releases/download/v1.0.16/libde265-1.0.16.tar.gz"
  sha256 "b92beb6b53c346db9a8fae968d686ab706240099cdd5aff87777362d668b0de7"
  license "LGPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7fc887ff6de361861449c51bd6cfb8a31ab93a91f1d4d76e41332f9e44627afe"
    sha256 cellar: :any,                 arm64_sequoia: "3ae5875dd16e86734c59ff156ef6f03f0cc11f972193e678241ec10ac19dbf48"
    sha256 cellar: :any,                 arm64_sonoma:  "08a3fd4a3e01254f12590f292157a8b92a898d9b4d31659f3e25d34a164f9cd6"
    sha256 cellar: :any,                 arm64_ventura: "2837e8b323ed255ca2efb59a266cd5da0740524758df2d51e5a9834da79720f8"
    sha256 cellar: :any,                 sonoma:        "dcee9a83c604fc27ccb54af849fe45124e12dbf66b63c53d5775aa0c1a49e34c"
    sha256 cellar: :any,                 ventura:       "55f13980c54642c830932f317c1e458882daca74f80118cff8e4bb204ac1b0cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "650fa2c9ab2bd73545addb81842bb9442d929b25af4eef7fedfb34a4f93cfe87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bca710186d841ef99740adb1bdd747ae4b0bebb4ffcfa4bc4024199b26c0a5d"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
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
    (libexec/"bin").install bin/"block-rate-estim",
                            bin/"tests"
  end

  test do
    system libexec/"bin/tests"
  end
end
