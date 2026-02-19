class Nmrpflash < Formula
  desc "Netgear Unbrick Utility"
  homepage "https://github.com/jclehner/nmrpflash"
  url "https://github.com/jclehner/nmrpflash/archive/refs/tags/v0.9.26.tar.gz"
  sha256 "51cc37b85b04ff59dda1a5b83ba443d7f577677305aab653855d7c1f78c6d704"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "969c0f20ce2ee2fa3db03f62bc840c992311213e4c90993bf4e5e37c6e57fb59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "607aebe8626467ea165ccbf446d2d85f478bd2ae69b42c48ae761f55cd80d7a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81d2e99b2b0658aff0212a075bda180876e0d989e652c80b37a40ef24756186b"
    sha256 cellar: :any_skip_relocation, sonoma:        "34d3bc774d1dff1c65c8ba34a6805e3b0e162f47218fa360b9e8924016772eeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cf58744d597c556785ba1d57339c9512e0d8fb350f8daaf3bd97cdbbd9bbeda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10a48b3841decf47dc994609dff710a5cedbc8d1a54b924935f674344e74265b"
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
