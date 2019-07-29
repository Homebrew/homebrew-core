class Libde265 < Formula
  desc "Open h.265 video codec implementation"
  homepage "https://github.com/strukturag/libde265"
  url "https://github.com/strukturag/libde265/releases/download/v1.0.3/libde265-1.0.3.tar.gz"
  sha256 "e4206185a7c67d3b797d6537df8dcaa6e5fd5a5f93bd14e65a755c33cd645f7a"

  bottle do
    cellar :any
    sha256 "01179a3f87c9cf12df83db31e3a9de568a37970624b623b27ec92ce2e5513fb0" => :mojave
    sha256 "318155fde344fe1742f354396bd65fbd2b1ed14f420131f3ed5ff569d5a6b38f" => :high_sierra
    sha256 "5f247bee31e10b2217023a64e5ef841566f1ee5edc7227dc15110fb507405269" => :sierra
    sha256 "942f19c7b70c6bc6510715c13752bb99e7a4793f1f028245fd2f2b798a8efe56" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-sherlock265",
                          "--disable-dec265",
                          "--prefix=#{prefix}"
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
