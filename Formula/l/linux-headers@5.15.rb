class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.193.tar.gz"
  sha256 "a7021e3394ca3727a8af56b52df8c715dae088372fe0edefbc98df0510d7357a"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "b0d4106be3a45577dd7cfa8326597ad3c43fce37194b8b971bf72e15a6cfad1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1dd235b32a4314b13ff7de72c8733a976e143996d6e6b3358d8e66db3e84c49f"
  end

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
