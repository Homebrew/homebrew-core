class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.200.tar.gz"
  sha256 "f6f41c3821b3996d5911c03d57f65aa2128cd6526f725489618bcc76dc9b2a6c"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "6e1132f2f5e60e4ac350ed8e4663bfb0bd301158a42fc2e5bccddab666392414"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2c331d20a231d96b1d64015d48d3f2cc0363b251426342e3950bb4d6b87e0928"
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
