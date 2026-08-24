class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.217.tar.gz"
  sha256 "dda9b4970d55b9940073033f9d1d86956aadcea988d6e8ee8d5397cdb5527626"
  license "GPL-2.0-only" => { with: "Linux-syscall-note" }
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "2a3bb2d2105b1e9c9c4d2774529f293ae5f193b20a2c121bfbcab6c77ec64eb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ac1f612ba0f13daaccb77935bdc29b5779f54c03bdccb8c93ff902fa95ab8e60"
  end

  keg_only :versioned_formula

  depends_on :linux

  def install
    system "make", "headers"

    cd "usr/include" do
      Pathname.glob("**/*.h").each do |header|
        (include/header.dirname).install header
      end
    end
  end

  test do
    assert_match "KERNEL_VERSION", (include/"linux/version.h").read
  end
end
