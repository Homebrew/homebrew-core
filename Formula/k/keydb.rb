class Keydb < Formula
  desc "Multithreaded fork of Redis"
  homepage "https://keydb.dev"
  url "https://github.com/Snapchat/KeyDB/archive/refs/tags/v6.3.3.tar.gz"
  sha256 "c6798cea3fe4ba4d1b42eea6ca2cfaee261786d12bf30aef1a53211d25ab66d9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8eb7f30c414db777e866e4f0f5fa00b8e3406902ed2b7e09a88c369615a7b580"
    sha256 cellar: :any,                 arm64_monterey: "da4c073cedd43ccf6c3086a9c9c96852475439e2044588e40efd55cfe52f7f79"
    sha256 cellar: :any,                 arm64_big_sur:  "2e65f90555fba6d2e2254f114d74b7545475cb37d9894c76aefd0cfbf30b3c55"
    sha256 cellar: :any,                 sonoma:         "2a02c09e63aa238eb39ddeeaa8941c342fbec474bf109577bac1c3d907443cc2"
    sha256 cellar: :any,                 ventura:        "a93c3a36287d84a546371d5d2d55a1d760f05758e75e2dbaa61d06271b80208f"
    sha256 cellar: :any,                 monterey:       "2a85bfdf4f739d880c374461d3044ad116fbd7f9bad675f18c48fb9f8fb5c69b"
    sha256 cellar: :any,                 big_sur:        "4ac158c200544f7f88f252121dbb98fecc4e3f969b97425cd072c468199c55e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e2ed376677540d33fd35070da1ce365a164784f9b9dea6f092593d7a7364bc6"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "snappy"
  depends_on "zstd"
  uses_from_macos "bzip2"
  uses_from_macos "curl"

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/keydb-server --test-memory 2")
    assert_match "Your memory passed this test", output
  end
end
