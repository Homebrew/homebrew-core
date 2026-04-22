class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.203.tar.gz"
  sha256 "f5ef670c7f025434496d9526df24f1b4af1d6d6f692879e439eef6d1f7a14be8"
  license "GPL-2.0-only"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "1def4620b7774e1ac02b83ba4923d6548786ec9f58dab5bc03fa60bd46efce1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "86c4711eb59d1414957f2c3698fafb0dc9c1946f56ffebcb0fa41bedfde8591c"
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
