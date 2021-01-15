class LinuxHeaders < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.9.16.tar.gz"
  sha256 "f4e27357aba6d5a69ab473e53a93353f9bed1a7e8ee43a6d8e186770d6a79586"
  license "GPL-2.0-only"

  depends_on :linux

  def install
    system "make", "headers_install", "INSTALL_HDR_PATH=#{prefix}"
    rm Dir[prefix/"**/{.install,..install.cmd}"]
  end

  test do
    assert_match "KERNEL_VERSION", File.read(include/"linux/version.h")
  end
end
