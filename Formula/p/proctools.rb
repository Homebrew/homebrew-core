class Proctools < Formula
  desc "OpenBSD and Darwin versions of pgrep, pkill, and pfind"
  homepage "https://proctools.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/proctools/proctools/0.4pre1/proctools-0.4pre1.tar.gz"
  sha256 "4553b9c6eda959b12913bc39b6e048a8a66dad18f888f983697fece155ec5538"
  license all_of: ["BSD-3-Clause", "BSD-4-Clause-UC"]

  livecheck do
    url :stable
    regex(%r{url=.*?/proctools/[^/]+/proctools[._-]v?(\d+(?:\.\d+)+(?:pre\d+)?)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a04c37c6e995cbce8ff70386029b5b3a00c61cbd1e9c7399cbb177670035df8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f9cc18c0b6d9837cad062ce69de2544bf534d4bcc7380230b81ac126dc2ca4be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5be8d4a80309fe84a132613a2338daa436e041b98569d0846648fc6e35e3d452"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "954a65be7f21a18e1defc733342a049bef559402c5b14b8fb8879cff05cb7af5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7616c8fd8dae9c8eed3686b7bf76cf2ecd46b44ba8b0cfed12c22c9f3f18c69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "526b231a9b0d8e8d2a4155507bc77e2cc3dab60a6905c44c3371839b391e0b74"
    sha256 cellar: :any_skip_relocation, sonoma:         "05aed8b98b5faf6ac1e0026998e7ab30de66318c9165bd4efb78ff35eecb7473"
    sha256 cellar: :any_skip_relocation, ventura:        "7beaae2873e1c6c390b4a9471ea9bc4f16cb4a4f591a7ba5119546ab46169132"
    sha256 cellar: :any_skip_relocation, monterey:       "9bdbe7d4b78f52517f8c215c2aea77a49e988d9fb473d6277b5dbe1cc4b737e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a8ffd535edba47371a0617666b6eced7b0b13c4b27b4303b483d71f07de2e04"
    sha256 cellar: :any_skip_relocation, catalina:       "f0fe70530d22c270ac3d5a105f2dbbbb0dc6a664acd03f3ad7da3f86255fd548"
  end

  depends_on "bsdmake" => :build
  depends_on :macos

  # Patches via MacPorts
  {
    "pfind-Makefile"        => "d3ee204bbc708ee650b7310f58e45681c5ca0b3c3c5aa82fa4b402f7f5868b11",
    "pfind-pfind.c"         => "88f1bc60e3cf269ad012799dc6ddce27c2470eeafb7745bc5d14b78a2bdfbe96",
    "pgrep-Makefile"        => "f7f2bc21cab6ef02a89ee9e9f975d6a533d012b23720c3c22e66b746beb493fb",
    "pkill-Makefile"        => "bac12837958bc214234d47abe204ee6ad0da2d69440cf38b1e39ab986cc39d29",
    "proctools-fmt.c"       => "1a95516de3b6573a96f4ec4be933137e152631ad495f1364c1dd5ce3a9c79bc8",
    "proctools-proctools.c" => "1d08e570cc32ff08f8073308da187e918a89a783837b1ea20735ea25ae18bfdb",
    "proctools-proctools.h" => "7c2ee6ac3dc7b26fb6738496fbabb1d1d065302a39207ae3fbacb1bc3a64371a",
  }.each do |name, sha|
    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/proctools/patch-#{name}.diff"
      sha256 sha
    end
  end

  def install
    system "bsdmake", "PREFIX=#{prefix}"

    ["pgrep/pgrep", "pkill/pkill", "pfind/pfind"].each do |prog|
      bin.install prog
      man1.install prog + ".1"
    end
  end
end
