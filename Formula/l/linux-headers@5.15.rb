class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.225.tar.gz"
  sha256 "529a3cdb7aa483f9b24953a3e2762058b260bc0acaeefd679f401b81905ae42a"
  license "GPL-2.0-only" => { with: "Linux-syscall-note" }
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "2e84f7a20ee018a1e4e871863f03b2c5ea3d57f34808e6932c7f42c77d5c2af0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9a3618b88cc12ecc0be48c15d41fe124ef97a0c95171b80a860cc6d84d0a1b49"
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
