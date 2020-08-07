class Libde265 < Formula
  desc "Open h.265 video codec implementation"
  homepage "https://github.com/strukturag/libde265"
  url "https://github.com/strukturag/libde265/releases/download/v1.0.5/libde265-1.0.5.tar.gz"
  sha256 "e3f277d8903408615a5cc34718b391b83c97c646faea4f41da93bac5ee08a87f"
  license "LGPL-3.0"

  bottle do
    cellar :any
    sha256 "7621e45fa0b119aff03a8c3ff3ed94bec24a2844a28cc10603b96e531afc3dab" => :catalina
    sha256 "f0b536c23ac8080dd7946dd3bcbe2517f4a9b7e50b815e1ba745277c9982e6ac" => :mojave
    sha256 "9815c937712d61876a1cb61241b60164f65cf463d6594d46857f691d37775882" => :high_sierra
  end

  def install
    extra_args = []
    extra_args << "--build=aarch64-apple-darwin#{`uname -r`.chomp}" if Hardware::CPU.arm?

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
