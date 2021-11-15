class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20210808.tgz"
  sha256 "f158529be9d0594263c7f11a87616a49ea23e55ac63691252a2304fbbc7d3a83"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/byacc/"
    regex(/href=.*?byacc[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6af3430a5c03eac7bb9df4decaaf2df95d69c65fd8b2316151f13bb8bbfe832b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea7bf5ff3f3685261e4ebcdb7f4b137806ef294e6f88a81aa7723f95bcf04645"
    sha256 cellar: :any_skip_relocation, monterey:       "b744bf04f5f362eefcee569646ca9bb0ac772b1f71fa7eb27e0e2ea91f6770e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6d14688cd201d229766c304bc568bf841e0660ac4309063f6a6a16d4217ff52"
    sha256 cellar: :any_skip_relocation, catalina:       "d610e1d60b0a483e82b5d2f710960e914f7738535a0ac7125ab0c6465d89abe6"
    sha256 cellar: :any_skip_relocation, mojave:         "bc45ca552799eddfc91158ab0ebd9c8152828e1a21d992b5d7402813a72dd2d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "387ebfc719409f19a7ccabbc79ba1a93213b378881bce09f8bba14487757e556"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end
