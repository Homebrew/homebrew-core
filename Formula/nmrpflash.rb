class Nmrpflash < Formula
  desc "Netgear Unbrick Utility"
  homepage "https://github.com/jclehner/nmrpflash"
  url "https://github.com/jclehner/nmrpflash/archive/refs/tags/v0.9.18.2.tar.gz"
  sha256 "ba0afe584bf45567fc8156773554a2365b85c0ffbbdc322bfeda6f8c18674029"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b723e841284103a845c32aaba631d224fbab15f22c08ed18ca35899c0f78deca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0999657c0e10d397b5db09a7e2bf63d39024ef20dd7c65236d40a2c86ee6b2e2"
    sha256 cellar: :any_skip_relocation, monterey:       "2a82f417f5e87b28ac65c7a604f91e77c0aa28fa53d2268e26309069f1a2b55c"
    sha256 cellar: :any_skip_relocation, big_sur:        "312245138956b9ae5fe5d9930d17434466a903aa9440305b1d7a93832e8eb349"
    sha256 cellar: :any_skip_relocation, catalina:       "2e64bd4153112e58754868afbd6f94dbec0ada65cf62e40bd6be01a8a5f342ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94505b44d8307d1938dbfc0a60f33f5f465bf7ce1893b98b0a8b2f84778a136e"
  end

  uses_from_macos "libpcap"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libnl"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "VERSION=#{version}"
  end

  test do
    system bin/"nmrpflash", "-L"
  end
end
