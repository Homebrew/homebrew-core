class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.216.tar.gz"
  sha256 "f7f458e71531e218e82fc27bd5b4501e3c4d11783344cf13e35bb09580743b41"
  license "GPL-2.0-only" => { with: "Linux-syscall-note" }
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "99d21a15deeeaac8b5343c49a57ff3cc5441b619b1616cb2ea7c9ffa6198b11a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "00aa2b40b99ff646f9907cfc342f502fec5e23bbbb46fdb075aa35f248774687"
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
