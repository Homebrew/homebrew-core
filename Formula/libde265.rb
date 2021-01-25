class Libde265 < Formula
  desc "Open h.265 video codec implementation"
  homepage "https://github.com/strukturag/libde265"
  url "https://github.com/strukturag/libde265/releases/download/v1.0.8/libde265-1.0.8.tar.gz"
  sha256 "24c791dd334fa521762320ff54f0febfd3c09fc978880a8c5fbc40a88f21d905"
  license "LGPL-3.0-or-later"

  bottle do
    cellar :any
    sha256 "6c809d037d6fe6c99a4c1492882c1e4ba720c9ead911b587da26dcb352fc5524" => :big_sur
    sha256 "856e3db9a951f15fc2e3c416ddf64c8336d405fc1e407e4728804009034367e6" => :arm64_big_sur
    sha256 "774fe5c9c849784aa10648fe3fae971c7d702a47807b6954c8a8763368bce9fc" => :catalina
    sha256 "344e3a6eab4addecd812a51ef0d6e0db5e894c26a455603a6b4f4972757a5994" => :mojave
    sha256 "bcb11c6ab6f03a76ae39a1972ed5a8779e785fdc6a62591823bdf8e2ac102890" => :high_sierra
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
