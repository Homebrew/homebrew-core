class Dpcmd < Formula
  desc "Linux software for DediProg SF100/SF600"
  homepage "https://github.com/DediProgSW/SF100Linux"
  url "https://github.com/DediProgSW/SF100Linux/archive/refs/tags/V1.14.21,x.tar.gz"
  sha256 "2bab3df0b971e66f574db33daa1687d1a064eed6b3e99d97c265bfce35470ddf"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4f5102a2acb2ba277359e059eb1bfc1c18b9608625c56b67b8a37c3bcc0208d7"
    sha256 cellar: :any,                 arm64_sequoia: "46dc23e75280d9ee1b6d06945dbbe02c5df6548a593a463dabf7c8f08a2cb805"
    sha256 cellar: :any,                 arm64_sonoma:  "6305d2c0681a4e0d1a1c759e4d9368a3e479d3cb47e4ad56c1510bde6eac526e"
    sha256 cellar: :any,                 arm64_ventura: "1999933a7cfd48060c8add8b68b1381f4ef3eb81bc60effd9e5693aed2e9fe00"
    sha256 cellar: :any,                 sonoma:        "dc2fb2e33afad5b3aefec987d0f8e39de09fea5f8b2ea4face4e043c0f3e624d"
    sha256 cellar: :any,                 ventura:       "56e693f599c54b059039fd369cf77eee88fd39a9b2e9490e74021e5fdcd1081f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3808a79c440d4d319da04ad1623e85901363c5cfe7a07d5a48c245547e4aa2a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd4bb5c62758c86baf6c6a8211260e41c9311d3660d46d7f94f4b89bf2dd7b41"
  end

  depends_on "pkgconf" => :build
  depends_on "libusb"

  def install
    system "make"
    bin.install "dpcmd"
    (share/"DediProg").install "ChipInfoDb.dedicfg"
  end

  test do
    # Try and read from a device that isn't connected
    assert_match version.to_s, shell_output("#{bin}/dpcmd -rSTDOUT -a0x100 -l0x23", 1)
  end
end
