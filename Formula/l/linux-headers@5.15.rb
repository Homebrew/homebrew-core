class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.206.tar.gz"
  sha256 "125d430ae3f469c6feeb46d5aabf449e83ff93d2cbe98a456049fe74e7d438a5"
  license "GPL-2.0-only"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "b0c9c26e805b2be7895dcd084d4c04a68bde0790a284e43b379365d66122630e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "be1561df8facc6fe2f1f66479a642cd35dab0fc6177acfbee234c43b8833d131"
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
