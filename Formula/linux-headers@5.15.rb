class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.93.tar.gz"
  sha256 "406dfa1c09fb88a43db7686c0ddc71e33a22b730665b5175b0ab0b28ac924220"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2007347b61710f30ce4587ada3b043d35d2a9b755f92738f0caaba829d3cdc5f"
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
