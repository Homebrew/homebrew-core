class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20230201.tgz"
  sha256 "576cc9d9ae5e22503ed5e3582498cf2cccacef401969106420547b4d05c87d76"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/byacc/"
    regex(/href=.*?byacc[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa9607f33e445754df53a511e4709c20c59b6153fb14bc46145b8e72ba494a57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c49f9e9a375aafb1e91c440f672b87169947bfb6ed5e7d2ac549ccd789a14b6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2808bfeaaaf39410087e2d69c71aed20d7cc623e0694a67ab0f1a4cf9438b04"
    sha256 cellar: :any_skip_relocation, ventura:        "28fda19c22a42d213e96d96a3339e6153f035844c01795b850ef684b3054f507"
    sha256 cellar: :any_skip_relocation, monterey:       "73cde3c5b5e0d8a10272c6ffc8be39fcd8c9317b0879c2abe797271cf44264a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "0337093fd4866b45c5498e5ccf4aa2235dc7f4a80a35f14028c140feb9ef22af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d35126d07e966467a7c3a2174288357542ad7e2bc56a98879c3e0ef2414d5dd1"
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
