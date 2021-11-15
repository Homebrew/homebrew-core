class Abnfgen < Formula
  desc "Quickly generate random documents that match an ABFN grammar"
  homepage "http://www.quut.com/abnfgen/"
  url "http://www.quut.com/abnfgen/abnfgen-0.20.tar.gz"
  sha256 "73ce23ab8f95d649ab9402632af977e11666c825b3020eb8c7d03fa4ca3e7514"

  livecheck do
    url :homepage
    regex(%r{href=.*?/abnfgen[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1ebec3242ff2bd1ad767c152536f7c33ec454dafbf902dd1b0bbf4ce026b856"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3c6fe963835658791592b3846bcab8bfeafbee2c63f3fb804405ce72ed2e64a"
    sha256 cellar: :any_skip_relocation, monterey:       "f80717b29159352a309473e370a1ed615aed0cb2b9f822daf556b9f691bc1a35"
    sha256 cellar: :any_skip_relocation, big_sur:        "bddcdbc3e7993d70dc27f99fd18b439ecb25cd338c8c88762d7d3842439fd2f2"
    sha256 cellar: :any_skip_relocation, catalina:       "c1531bab58a352221fca0cc5b73db2d9f206e1b98272ff06a90d72aa9e991925"
    sha256 cellar: :any_skip_relocation, mojave:         "b553651b5500f66d10a369f4d8862ed9c6d2b39d395c43e372b346b4c7bfead0"
    sha256 cellar: :any_skip_relocation, high_sierra:    "3a62e72bec09b9bfff637710db366f713abc95de45437aeadbfa87a87dfc040c"
    sha256 cellar: :any_skip_relocation, sierra:         "0d69f39473838a8e46fb02009329e05be6eeaed579ff5533a09cbbecd8d46a2d"
    sha256 cellar: :any_skip_relocation, el_capitan:     "fd51cb760ed8afb8a9e3dd5d05c8efa832361b238ad95410fb2864c91c081825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1f2bb09e4f700df87e071039bceb2c0ea8d6082487163fd3e5ed271712e3e3e"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"grammar").write 'ring = 1*12("ding" SP) "dong" CRLF'
    system "#{bin}/abnfgen", (testpath/"grammar")
  end
end
