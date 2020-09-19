class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/2.4.1.tar.gz"
  sha256 "60e13e56dd37efe585d0c6b681b49da17838771a311b1781f7f95a625f3b2032"
  license "MIT"
  head "https://github.com/clibs/clib.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "24aa8d90235eb0d885e9440536ba1e4d5e359a367924f0774f97a6f40e3d58c9" => :catalina
    sha256 "71b5c364b05425516446e6a5bb34b9d7c4e4ce687e9b7b7cccb779febc5fc78a" => :mojave
    sha256 "8c403b159aac0e00139afcc7e4719e76c8a169b1a0c7c6b30e2ec74f7460c0a0" => :high_sierra
  end

  uses_from_macos "curl"

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
