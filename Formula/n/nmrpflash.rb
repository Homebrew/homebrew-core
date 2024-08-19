class Nmrpflash < Formula
  desc "Netgear Unbrick Utility"
  homepage "https://github.com/jclehner/nmrpflash"
  url "https://github.com/jclehner/nmrpflash/archive/refs/tags/v0.9.22.tar.gz"
  sha256 "cef3b54c798a4a049a2d9b959e1d6a0ac2f4f31b802d6be4f79351b9a96c3f39"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7707770da6f42c1be7584a916ec0c71413daaf4d0016b21d805428937a2ae05e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea1a68cc3899bbfd347fa8ccb4f4c57eb4c67d4eb7fd0fc1597d03f4d485167f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4ed486e5af0f6ba6a942d62fac781aefeba10ccee0538ce7da1d54981ac8740"
    sha256 cellar: :any_skip_relocation, sonoma:         "adfd26f227285f47a5c456a66cdd8a8c84d9640156c8c98009f7df24ba493be8"
    sha256 cellar: :any_skip_relocation, ventura:        "22a6bfa73038cf62b5fed6de8dfee37c528a5fbeb81a41a90288c6a9dfb540b0"
    sha256 cellar: :any_skip_relocation, monterey:       "9679ae12b03689f3d5bddf1101ba005b872ae4762a11b8cbfd8df2fede54d0aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e8e4c97df6dbe64e51af2e0d912253154c69a691cbe78cb0ff3c4f5afe85a2c"
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
