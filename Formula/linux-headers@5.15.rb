class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.57.tar.gz"
  sha256 "d33d0e62f05d90d579eb0cc51343f48c32eb11e4fef0306c374b908212f51578"
  license "GPL-2.0-only"

  keg_only :versioned_formula

  depends_on "rsync" => :build
  depends_on :linux

  def install
    system "make", "headers_install", "INSTALL_HDR_PATH=#{prefix}"
    rm prefix.glob("**/{.install,..install.cmd}")
  end

  test do
    assert_match "KERNEL_VERSION", (include/"linux/version.h").read
  end
end
