class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.202.tar.gz"
  sha256 "7459799f7138c67817f587225d453647b2219f5371d0b610823a5fcecbc496d8"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "12cc44a56a7a8bb79473df38494801b0989c7250d3e65709b06268c66ab9bb8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1b5ab4028d4aead8e55c71fbcd62811ea37368a5e2dbe26ec8cfe472d2e8ad9b"
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
