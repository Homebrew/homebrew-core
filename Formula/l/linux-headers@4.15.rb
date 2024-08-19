class LinuxHeadersAT415 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.15.18.tar.gz"
  sha256 "ca13fa5c6e3a6b434556530d92bc1fc86532c2f4f5ae0ed766f6b709322d6495"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "720cb4d024febce4f9195b11ac452d707c5a22abe79b1aa3c802e8a56a7cabae"
  end

  keg_only :versioned_formula

  # Linux kernel 4.15 is EOL with final release on 2018-04-19.
  # It is still used in Ubuntu 18.04 LTS but we don't track Ubuntu's versions
  # and we skipped to Ubuntu 22.04 LTS for Linux bottling.
  disable! date: "2024-02-16", because: :deprecated_upstream

  depends_on :linux

  def install
    system "make", "headers_install", "INSTALL_HDR_PATH=#{prefix}"
    rm Dir[prefix/"**/{.install,..install.cmd}"]
  end

  test do
    assert_match "KERNEL_VERSION", File.read(include/"linux/version.h")
  end
end
