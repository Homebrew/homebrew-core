class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.85.tar.gz"
  sha256 "d046e26c5851943d612528beecc2a187c52ca5cd1ee0af092048c47e447c4e35"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e5e45a879917b4c823e5819f5d0c7c39269bcfee10aa19de6a60d81b086f4e19"
  end

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
