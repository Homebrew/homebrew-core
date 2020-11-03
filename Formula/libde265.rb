class Libde265 < Formula
  desc "Open h.265 video codec implementation"
  homepage "https://github.com/strukturag/libde265"
  url "https://github.com/strukturag/libde265/releases/download/v1.0.8/libde265-1.0.8.tar.gz"
  sha256 "24c791dd334fa521762320ff54f0febfd3c09fc978880a8c5fbc40a88f21d905"
  license "LGPL-3.0-or-later"

  bottle do
    cellar :any
    sha256 "d8993d03ab225a6d98462afacb7afdcdefae09ec0ee8d1c949b3c227ee61c462" => :catalina
    sha256 "04b06c8b262664a205332006d0779cf6c9b2808864343750e53a8b2f675332cf" => :mojave
    sha256 "d243a5d8462cfcb0a960918628ff21be7166d73706227f430f1e4572ff31eb33" => :high_sierra
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
