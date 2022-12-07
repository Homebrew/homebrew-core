class LinuxHeadersAT516 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.16.20.tar.gz"
  sha256 "3fa593807c25d772f3b876ccdb9c4a073f06dce7d5e934ef8ecd0de73b87fd1a"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "06c20f8c85abb46ed0869470e3f73185b4cdd47ca196e01faa4b591da12d5869"
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
