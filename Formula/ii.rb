class Ii < Formula
  desc "Minimalist IRC client"
  homepage "https://tools.suckless.org/ii/"
  url "https://dl.suckless.org/tools/ii-1.8.tar.gz"
  sha256 "b9d9e1eae25e63071960e921af8b217ab1abe64210bd290994aca178a8dc68d2"
  license "MIT"
  head "https://git.suckless.org/ii", using: :git

  livecheck do
    url "https://dl.suckless.org/tools/"
    regex(/href=.*?ii[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9452385f64727d3e54a45e3e7e24a41bb4014df20ffd6d1ec7cd75de14749d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5de14cd12cba7a7ff58f2c5db87c300a3dcf69268dbbfbca552dbaf575568c0"
    sha256 cellar: :any_skip_relocation, monterey:       "760f3e4bd676ff26340b2796568d5e5b3727feb5da2094996ecb7ea0c1ecc4cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "a58cf380ab73f600dadce4712328013a3ea3b0b65009fda1a3d2dc5e92741716"
    sha256 cellar: :any_skip_relocation, catalina:       "deb41b4c38d4b8e6cd2f3e9d8acea872a8daa694486ee59edd684248a7e74f4b"
    sha256 cellar: :any_skip_relocation, mojave:         "c8e535b535af9adf8c3c3e760849f581d3e93ec227ae9f0ae2f30490b44e9c4d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "dcc9e7c86395491f5a62dd87dfcfb0f1b8b89a8f5ceb4e767ac70cf60ef350cd"
    sha256 cellar: :any_skip_relocation, sierra:         "a83511296e08d8ec1d126bb09574b02856f382f3f504b6f2b256cab6bd645ed1"
    sha256 cellar: :any_skip_relocation, el_capitan:     "eeba4fb4ec437895a9946bbbb00186ff05277ce9d57e8bbe29e1db5596d8a70f"
  end

  def install
    # Fixed upstream, drop for next version
    inreplace "Makefile", "SRC = ii.c strlcpy.c", "SRC = ii.c"

    system "make", "install", "PREFIX=#{prefix}"
  end
end
