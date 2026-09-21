class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.221.tar.gz"
  sha256 "966d6d93b6989fedde7dacbf12ed24c8cc5142896a7c4739a76d83a7be1a4787"
  license "GPL-2.0-only" => { with: "Linux-syscall-note" }
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "bfda0699ee2a1d9f29122f115cc01829374876a79b7b9217b6154ad9f06391f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e17b8718dd6b03dc429f967fdd8735e361d29ead1d8442049656fbbda9d5e16e"
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
