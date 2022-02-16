class LinuxHeadersAT516 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.16.9.tar.gz"
  sha256 "ca84521580c9e2a5d7648a6b98150780b0e65bc8fac85c3a07d00b1b9aa68ad3"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "71cb27ac2bb2f30bf7eba3d3da5500d6b69d389b23d755902ef22b6afc1570b2"
  end

  keg_only :versioned_formula

  depends_on "rsync" => :build
  depends_on :linux

  def install
    system "make", "headers_install", "INSTALL_HDR_PATH=#{prefix}"
    rm Dir[prefix/"**/{.install,..install.cmd}"]
  end

  test do
    assert_match "KERNEL_VERSION", File.read(include/"linux/version.h")
  end
end
