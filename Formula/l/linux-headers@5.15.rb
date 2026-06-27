class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.210.tar.gz"
  sha256 "0ce029c0f22637de26a2382cdd76e22c9dcfa7704788b8be42ff0812ff62fab9"
  license "GPL-2.0-only" => { with: "Linux-syscall-note" }
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "5ad2ba785ccff022c5a954519fce771907cde2e3736da9b3fb912318abf3d12d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8ba06b73409112b59541934fd9ff876ce5d0bbff7686dca3b48972f8bfacff48"
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
