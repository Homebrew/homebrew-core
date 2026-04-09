class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.202.tar.gz"
  sha256 "7459799f7138c67817f587225d453647b2219f5371d0b610823a5fcecbc496d8"
  license "GPL-2.0-only"
  revision 1
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "6cbf863563b2e3c05b2ca1be1e7ef340286d50333ff00a9d7657da75efd39bd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f0b371a097922a88d08903513193bdad78f25d03d8ecf6cd195e921d8ba6a3f7"
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
