class LinuxHeadersAT44 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.4.302.tar.gz"
  sha256 "66271f9d9fce8596622e8154ca0ea160e46b78a5a6c967a15b55855f744d1b0b"
  license "GPL-2.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "b809f68c023e71c860af7b6fa6f57f6e3e55130fc69b20fc42f8c4c9685b7b3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2b2ca7202c544d6a14778915175fc811e370cd7a5249c6d0216c83d78cc421ed"
  end

  keg_only :versioned_formula

  depends_on :linux

  def install
    system "make", "headers_install", "INSTALL_HDR_PATH=#{prefix}"
    rm Dir[prefix/"**/{.install,..install.cmd}"]
  end

  test do
    assert_match "KERNEL_VERSION", File.read(include/"linux/version.h")
  end
end
