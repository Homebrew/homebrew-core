class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.205.tar.gz"
  sha256 "0c1567e6a8f4f834957d56bed4996d6e20cca2733ac4860bc98b1d4c9f4c3669"
  license "GPL-2.0-only"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "b46d6f0aa5cb78397b920cb207e38f9843e435c26bfb1afdc0fc204403f014a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "77e4c7c05946e5c8bd5a449280e345dbeae507da1746290d2285e00c07493a70"
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
