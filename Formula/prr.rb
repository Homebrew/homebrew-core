class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https://github.com/danobi/prr"
  url "https://github.com/danobi/prr/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "2b0353977e1dbf1ca89e550954cb04d269cfab5e888a8d9ec7366583cb32fa1d"
  license "GPL-2.0-only"
  head "https://github.com/danobi/prr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d182872df7155301e4baa5ec763b7531ec71fc2788ad6647ba81f0920766d7f6"
    sha256 cellar: :any,                 arm64_big_sur:  "67b94ea52b713f2d4ebb43b226f9dfe8ab77afafc7882b54fe2a8e8f11fb48cb"
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
