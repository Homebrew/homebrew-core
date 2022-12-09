class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https://github.com/danobi/prr"
  url "https://github.com/danobi/prr/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "15fc841f50c3313ca8646240e937fb76b87d5270cd3db64042e48e819745e5af"
  license "GPL-2.0-only"
  head "https://github.com/danobi/prr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f48e8173231abf5ebf0d0cab14c17d4e56b5761cc855506a2b5efa2a1087b48d"
    sha256 cellar: :any,                 arm64_monterey: "d182872df7155301e4baa5ec763b7531ec71fc2788ad6647ba81f0920766d7f6"
    sha256 cellar: :any,                 arm64_big_sur:  "67b94ea52b713f2d4ebb43b226f9dfe8ab77afafc7882b54fe2a8e8f11fb48cb"
    sha256 cellar: :any,                 ventura:        "f22f1933bf38c5d0332eb85ff96a05445d49b6825f91e686fe654a98ed1d2ad5"
    sha256 cellar: :any,                 monterey:       "543d3450e1fc617249d0d0706bc2997d0eaa928e7d5b4852d5dd204c88aa91a3"
    sha256 cellar: :any,                 big_sur:        "a22481f6e1558e25545abe5634ad2c92bdb3c43741a30472612da352d897d7f6"
    sha256 cellar: :any,                 catalina:       "baa01991c64459f78850d50e23db3ec2b7e119bdeec1befb3f315b4be8737457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16f3b7a6ee4738ee708c9e7bf3c490645d735ca7945446782f5b10f60bc9144a"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Failed to read config", shell_output("#{bin}/prr get Homebrew/homebrew-core/6 2>&1", 1)
  end
end
