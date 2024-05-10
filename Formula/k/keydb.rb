class Keydb < Formula
  desc "Multithreaded fork of Redis"
  homepage "https://keydb.dev"
  url "https://github.com/Snapchat/KeyDB/archive/refs/tags/v6.3.4.tar.gz"
  sha256 "229190b251f921e05aff7b0d2f04b5676c198131e2abbec1e2cfb2e61215e2f3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "010db9d77cfd61aa2195db11eb21e7e30be2b565a2b92c837c69c82bd325a237"
    sha256 cellar: :any,                 arm64_monterey: "eefed6df2c14cfbab28ac8ce65f888d011bed8a1edec7095b891ba2b418ea733"
    sha256 cellar: :any,                 sonoma:         "9c96a66a65ad45e31aded15e6a4306d1fc4c97d707a060a3c31bba357310449c"
    sha256 cellar: :any,                 ventura:        "0b94cbbcf2ba980719309b3545c5b63fa7328f3067d66dc8686e6db64a13a745"
    sha256 cellar: :any,                 monterey:       "ca35b258a5ae50f171e31795616d4fb569a40ae72c12566b511b4442ff91de8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66f4992328aeaa000bb75107076cb9d05eb8b3ce229e94a51262d33d853af1b7"
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
