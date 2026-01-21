class Libcap < Formula
  desc "User-space interfaces to POSIX 1003.1e capabilities"
  homepage "https://sites.google.com/site/fullycapable/"
  url "https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.77.tar.xz"
  sha256 "897bc18b44afc26c70e78cead3dbb31e154acc24bee085a5a09079a88dbf6f52"
  license all_of: ["BSD-3-Clause", "GPL-2.0-or-later"]

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2/"
    regex(/href=.*?libcap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "6cafec8e7f42270d9bb2c5dac6128cbbf9d0d09095aa3d39d63d23a92ec663c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "564227961f58a88d94ddea146625a6aba87f456f8a66b06e005c0c6f53552956"
  end

  depends_on :linux

  def install
    system "make", "install", "prefix=#{prefix}", "lib=lib", "RAISE_SETFCAP=no"
  end

  test do
    assert_match "usage", shell_output("#{sbin}/getcap 2>&1", 1)
  end
end
