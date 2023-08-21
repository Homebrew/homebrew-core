class Icbirc < Formula
  desc "Proxy IRC client and ICB server"
  homepage "https://www.benzedrine.ch/icbirc.html"
  url "https://www.benzedrine.ch/icbirc-2.1.tar.gz"
  sha256 "6839344d93c004da97ec6bb5d805a1db7e0a79efc3870445788043627162bbb1"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?icbirc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7117691853b4646f4697aa6d8392d7f96a1528f417090b0fa2bca8bb0ed8e10e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9aa9c813f70949fb1d7784cba81133d726fb9b32aca1bc057680e92003b67640"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b2e4accc4480ed21b70273e1bc92895e016e8100ce1e144b8dd3194d7d5217c"
    sha256 cellar: :any_skip_relocation, ventura:        "4ae98f289f25c779e82a5c839ac62d435a8b2b87f8649cf6f988f5caf42d633d"
    sha256 cellar: :any_skip_relocation, monterey:       "0ac58ac9e6553f986983d97b5db7c20cc2d28d2eb6abdf2f136c16f455876342"
    sha256 cellar: :any_skip_relocation, big_sur:        "60c1ccdb6ca739d0d4694d2f075507f4417cada103204c6b91ee966350ca745a"
    sha256 cellar: :any_skip_relocation, catalina:       "c1a639673100e6c8f2f5116b11c4c7a8b38cc0af73841c4d13e611f7605a8c1e"
    sha256 cellar: :any_skip_relocation, mojave:         "c353062cf16183b658ca999e477f2f4ac6040dd8d3a995fe2736a382d989ca8e"
    sha256 cellar: :any_skip_relocation, high_sierra:    "e258e2ca2bf835d76b7d509eac5417629451068c85fe729cbab7fc64e89df9c0"
    sha256 cellar: :any_skip_relocation, sierra:         "cbec4e472c640a63081f12723fc9d144f00aa00c9229ce5bfc2edd99199aee74"
    sha256 cellar: :any_skip_relocation, el_capitan:     "2f943e4af7a9c1e2524d9583b0ef5539988f68f56a8f8c483b2c2d1990fff21d"
  end

  depends_on "bsdmake" => :build

  def install
    system "bsdmake"
    bin.install "icbirc"
    man8.install "icbirc.8"
  end
end
