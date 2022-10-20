class Keydb < Formula
  desc "Multithreaded fork of Redis"
  homepage "https://keydb.dev"
  url "https://github.com/Snapchat/KeyDB/archive/v6.3.1.tar.gz"
  sha256 "851b91e14dc3e9c973a1870acdc5f2938ad51a12877e64e7716d9e9ae91ce389"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "db45b745f6bd2ec985ac208baf993e0eaf63213b04524729fd88a989b10f9450"
    sha256 cellar: :any,                 arm64_big_sur:  "186e3c93ffd0f867dfcabe61ef11573f886f3589429d6720cb541d0b40951dca"
    sha256 cellar: :any,                 monterey:       "42d02ad9f16092ad46f1897bd56f2002caf28466cb129ce0479acf0ab2ba5cbd"
    sha256 cellar: :any,                 big_sur:        "d0956eef5c45dd5515eebce726517de432d501045f0ce3e9501e10909b002442"
    sha256 cellar: :any,                 catalina:       "1bb8588ba5ebdbcfb4fcfe1be1884fed97e4669d431d9b972b9f92cbfc98c0de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e586d4eab07319cddbce1a92270f31950caf3a3f45b573f5425c6f80a4025a87"
  end

  depends_on "openssl@3"
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
