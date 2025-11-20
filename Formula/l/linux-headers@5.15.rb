class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.196.tar.gz"
  sha256 "d3c920fefedf1405e9eece7b8551e9fd05239c97d07a6aeb1f032dcab1ae1749"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "77a049837fb8b80067a7f4f188e5e724b55e2e8395144c742c7c5c44503402fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "667dd9a45a0d5846dfb5a0fb9db3b8c43c651c815f25a5ef020034cf74dface1"
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
