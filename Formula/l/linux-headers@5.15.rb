class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.211.tar.gz"
  sha256 "0ba548ffb9d382cec3c00d56380077216f18b73ea0d9bc099d988d6374d6ea9d"
  license "GPL-2.0-only" => { with: "Linux-syscall-note" }
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "306240e4abad98770d91d5a0b56f055b179b4521f4ba4d3de2da0c06eccf9afd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2f2b7a1db6d9eb8f18bffd0ded43ecaf5c66e2577825ac10d88ae083c5b2bc50"
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
