class Nmrpflash < Formula
  desc "Netgear Unbrick Utility"
  homepage "https://github.com/jclehner/nmrpflash"
  url "https://github.com/jclehner/nmrpflash/archive/refs/tags/v0.9.28.tar.gz"
  sha256 "8d3ec766b7f43bd060032db3cec40c500ef1edc562281f239e308595b66a4176"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f74bbe0adb690cce03b7e5e495785870447a4ae18caa326969b60663547f7505"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4fd59cb7a0d5bec2a5ac2e8d7ba7911ecb305aa806415267651cc088e33d6942"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ee6e761e2622b68057b9f59ed9a9c71669bf9b2296814d352c940e60a81795ad"
    sha256 cellar: :any,                 arm64_linux:       "bb9e2d326004cb82b913563568c2de2d1555dadc88340de0f76e854607febd47"
    sha256 cellar: :any,                 x86_64_linux:      "e93f577557ac11b0fc1d4d56197271ffe57dd68cadf3ea964a6a0d4d7d86de33"
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
