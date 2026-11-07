class Krunkit < Formula
  desc "CLI tool to start VMs with libkrun"
  homepage "https://github.com/libkrun/krunkit"
  url "https://github.com/libkrun/krunkit/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "ce714476e62db927cc872e4d2f066f5f756f6f54fef2f0cc4fc82329be75c86d"
  license "Apache-2.0"

  depends_on "rust" => :build
  depends_on "libkrun"
  depends_on :macos

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "edk2/KRUN_EFI.silent.fd"
  end

  test do
    assert_match "krunkit #{version}", shell_output("#{bin}/krunkit --version")
    assert_match "vcpus must be a minimum of 1",
                 shell_output("#{bin}/krunkit --cpus 0 --memory 1024 2>&1", 1)
  end
end
