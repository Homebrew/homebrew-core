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
    sha256 cellar: :any_skip_relocation, arm64_linux:  "80b5a048da82f36920a6700aec8e5799719836364df3832b8d8d0e2f5c9f1311"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f989f7675fc011b292863470e32ccfe4f3866f076af84611d0e7ee92a70a6965"
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
