class LinuxHeadersAT44 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/", browsed: "2026-11-18"
  # Track CIP project's SLTS as mentioned by release maintainer on final 4.4.302
  # See https://lore.kernel.org/stable/1643877137240249@kroah.com/
  url "https://cdn.kernel.org/pub/linux/kernel/projects/cip/4.4/linux-cip-4.4.302-cip116.tar.gz"
  version "4.4.302-cip116"
  sha256 "260469d3d98b0e82934734f149b99109df0fdd485b0b4fcecd1bd1db0b4987bc"
  license "GPL-2.0-only" => { with: "Linux-syscall-note" }
  compatibility_version 1

  livecheck do
    url "https://cdn.kernel.org/pub/linux/kernel/projects/cip/4.4/"
    regex(/href=.*?linux-cip[._-]v?(4\.4(?:\.\d+)+[._-]cip\d+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "b809f68c023e71c860af7b6fa6f57f6e3e55130fc69b20fc42f8c4c9685b7b3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2b2ca7202c544d6a14778915175fc811e370cd7a5249c6d0216c83d78cc421ed"
  end

  keg_only :versioned_formula

  depends_on :linux

  deny_network_access!

  def install
    system "make", "headers_install", "INSTALL_HDR_PATH=#{prefix}"
    rm Dir[prefix/"**/{.install,..install.cmd}"]
  end

  test do
    assert_match "KERNEL_VERSION", File.read(include/"linux/version.h")
  end
end
