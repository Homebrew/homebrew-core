class Fcrackzip < Formula
  desc "Zip password cracker"
  homepage "http://oldhome.schmorp.de/marc/fcrackzip.html"
  url "http://oldhome.schmorp.de/marc/data/fcrackzip-1.0.tar.gz"
  sha256 "4a58c8cb98177514ba17ee30d28d4927918bf0bdc3c94d260adfee44d2d43850"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://oldhome.schmorp.de/marc/data/"
    regex(/href=.*?fcrackzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7233ae34d595f418531944e3df6a9573175e53790d11a83504e082dbfe0c8075"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30a4350e75184bde4f486b5291061e59fff1e3063aa2a0c24751d98c764f2b18"
    sha256 cellar: :any_skip_relocation, monterey:       "62b27ef95d7fcbcdaa6027adf7f2983f9c8c93fe882937a364057f0479518ff3"
    sha256 cellar: :any_skip_relocation, big_sur:        "416fdb06f1ed0911126a51809e350450db5b09b723fb3aa16d0fddf9e05bd9aa"
    sha256 cellar: :any_skip_relocation, catalina:       "553e2ed7eb76dcf4a216bf214e0ceed63a72bda2e7fe9f5fb5f2ed86d8e7bfb8"
    sha256 cellar: :any_skip_relocation, mojave:         "9ac33112f0cb584aca3ac383ca3551cdda570e6f7337607c7f7db9d7f51b2e3a"
    sha256 cellar: :any_skip_relocation, high_sierra:    "a90e9d404b0ef939f6419559ed58143f556eb3e0b4fb0b8053bae35b82cc7a15"
    sha256 cellar: :any_skip_relocation, sierra:         "ce2d79b833f5805cbc475711a38db0a7a791b793b24b094e68f3ed54dfe5fd82"
    sha256 cellar: :any_skip_relocation, el_capitan:     "169a5e7ea0e7ee9d04dc7ecce5288ef3a096fc9875d9af134b342878ce8c55fd"
    sha256 cellar: :any_skip_relocation, yosemite:       "1e9a5e3d9d37ce1bf7338d3f12f84bf67b31de4e2a6eb1511f90458c45b1b810"
  end

  uses_from_macos "zip" => :test

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"secret").write "homebrew"
    system "zip", "-qe", "-P", "a", "secret.zip", "secret"
    assert_equal "PASSWORD FOUND!!!!: pw == a",
                 shell_output("#{bin}/fcrackzip -u -l 1 secret.zip").strip
  end
end
