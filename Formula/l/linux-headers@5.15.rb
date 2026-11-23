class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.226.tar.gz"
  sha256 "5f4e0c68d90472d31d57f97abab58cbaa8fbebaec6436c4d4c74bd089b3b66d7"
  license "GPL-2.0-only" => { with: "Linux-syscall-note" }
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    manifest_sha256 "69212a83c9d292388655754642c45acf239fad1a2505deed50352e27b2c97389"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "4a4f560bff8f5358408d7f318035de3ff45c21de0c4fb7407590c3424166f5c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2b424e1b8c70e08430e759897b60b1a4a15ca1a71fd838b6aedee11ea1c48b89"
  end

  keg_only :versioned_formula

  # Projected EOL of Dec 2026 and not used by any Homebrew glibc
  deprecate! date: "2026-12-31", because: :unmaintained
  disable! date: "2027-12-31", because: :unmaintained

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
