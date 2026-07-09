class Nmrpflash < Formula
  desc "Netgear Unbrick Utility"
  homepage "https://github.com/jclehner/nmrpflash"
  url "https://github.com/jclehner/nmrpflash/archive/refs/tags/v0.9.27.tar.gz"
  sha256 "a9de4296ec3db91e044f6ce5412342616920c6afda1df312bbeefc9013251f00"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccb3537298818c0381f10a7de1081423b84912b24aa1df5e363abade3a6f41b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9112a3e24563e48a37806c61be242cee74492b1eeae4b2c8a4deee3ac0adc689"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbc3adbdc13f0f05fb4a135c422f15fd5d457b997856695bcb9184bb25596864"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5c4571e22c359f94d2eba33ac0629bc279a50b4bf0b410d34f125d0b36c64a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b203614d3b7b379c5aac9ce88f264e2a384adfaca166d02889964a7490d09100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3546dc33507645b0d36167b06fde16ca804139fc7fa3d90a62a542e7cc3a893"
  end

  depends_on "pkgconf" => :build
  uses_from_macos "libpcap"

  on_linux do
    depends_on "libnl"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "VERSION=#{version}"
  end

  test do
    system bin/"nmrpflash", "-L"
  end
end
