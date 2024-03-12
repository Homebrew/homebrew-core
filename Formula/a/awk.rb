class Awk < Formula
  desc "Text processing scripting language"
  homepage "https://www.cs.princeton.edu/~bwk/btl.mirror/"
  url "https://github.com/onetrueawk/awk/archive/refs/tags/20240311.tar.gz"
  sha256 "5d46ab41595bcade23928a0aa9cff16972ee46e0a904a2a28c318324ccb669ce"
  # https://fedoraproject.org/wiki/Licensing:MIT?rd=Licensing/MIT#Standard_ML_of_New_Jersey_Variant
  license "MIT"
  head "https://github.com/onetrueawk/awk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3741938ae9a555470dcfe75975f7f98b6d838bce024b561b1e380b8112ee6981"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71dcc0d85c8d256e4ade6241eae82a18de3fc1fe20ca242961b9ed6b1e4206ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90467b080cdf1b139af338000c31586fd9b3ee387a214597b333d036354d6d63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e5e4df91f2628fdd27e655e1198cdf4f19e80aaf5235f4d987fa095638ad0ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e3669a1e2820cc1fd720c0af37ace49f1fea3da567983c61b3daccdefb05e9f"
    sha256 cellar: :any_skip_relocation, ventura:        "9ee6a4d8b1dcfb3808ef2dc51214017865924b0631b2107d381be48c8e93ae0a"
    sha256 cellar: :any_skip_relocation, monterey:       "14e36a488a1b66e579663545494c55bb9eeec31b71d72f23f810f69e04963333"
    sha256 cellar: :any_skip_relocation, big_sur:        "5943f92ced18437d64dbfc8653ea95f589517757316dd0dab9fac3ee1d39dbca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7675e8286eaea8e940da59bf608da314f34033606c9f0a0c71c98f1f698cf8a4"
  end

  uses_from_macos "bison" => :build

  on_linux do
    conflicts_with "gawk", because: "both install an `awk` executable"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "a.out" => "awk"
    man1.install "awk.1"
  end

  test do
    assert_match "test", pipe_output("#{bin}/awk '{print $1}'", "test")
  end
end
