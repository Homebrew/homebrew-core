class Nmrpflash < Formula
  desc "Netgear Unbrick Utility"
  homepage "https://github.com/jclehner/nmrpflash"
  url "https://github.com/jclehner/nmrpflash/archive/refs/tags/v0.9.24.tar.gz"
  sha256 "e902b8098a41c4c949fccd661dedcc8ca3791c83919a2b233286eae4752f25ea"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efeb54ff3d6742942eef67f323024dca99d99a44989dab0d45ab43a96946564d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7af0f8bd60d446593bd7ec7f32c4c4cf1ada677bd7033c69ab5591b0c5dbc3be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9e06317b3956276ab636c5c847a90554d61ce680ae0728116ea745afad94f99"
    sha256 cellar: :any_skip_relocation, sonoma:        "c840206c76bb926c5987fa4c201ec74ade3cd5a632bcccdc4b19a3a99d7cea0e"
    sha256 cellar: :any_skip_relocation, ventura:       "155a0a593129729d74995cfdfec9d7b10e42effed644c86e13ca7ab984f5d11b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c766ffefb78975b2c25d35726782e2b776888c7565b84c06f76db7f602c83db"
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
