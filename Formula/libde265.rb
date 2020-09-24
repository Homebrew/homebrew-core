class Libde265 < Formula
  desc "Open h.265 video codec implementation"
  homepage "https://github.com/strukturag/libde265"
  url "https://github.com/strukturag/libde265/releases/download/v1.0.7/libde265-1.0.7.tar.gz"
  sha256 "eac6b56fcda95b0fe0123849c96c8759d832ec9baded2c9c0a5b5faeffb59005"
  license "LGPL-3.0-or-later"

  bottle do
    cellar :any
    sha256 "119771a3c4b3da418886e2142d27d93191e37ecdebb46d07060f8f7b85fbb1c4" => :catalina
    sha256 "97450df80726024f5e1f099a4df07555caeead0a89b225ccf895aca0f033d98f" => :mojave
    sha256 "b1961f6dc7dbba259edafcee3b57741177ba9c6c6b1ccf43337167ec4d0cb246" => :high_sierra
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
