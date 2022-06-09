class Keydb < Formula
  desc "Multithreaded fork of Redis"
  homepage "https://keydb.dev"
  url "https://github.com/Snapchat/KeyDB/archive/v6.3.1.tar.gz"
  sha256 "851b91e14dc3e9c973a1870acdc5f2938ad51a12877e64e7716d9e9ae91ce389"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5f67cc6109bcf302b7298b9fdf3d6440851c822f1e41067711ce2f0acd997ebc"
    sha256 cellar: :any,                 arm64_big_sur:  "0d3c175286f20d74387ad91da01b6960428d726724c84b801a33d07f10c1206c"
    sha256 cellar: :any,                 monterey:       "5326f26759e31697f474186479d86f70190f79843245f7c3542a66c86c8141ed"
    sha256 cellar: :any,                 big_sur:        "1e51a0da309923c61c5c5e00a1d64671b95e5b02a5fd2f6dbfe4f5b9ac3f91e2"
    sha256 cellar: :any,                 catalina:       "6766829c11cdac2d5610e37b4e0a51f16f1821754cf01d47bd3acd1e7e0bc2c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a839ca5809be0438bc6eb68834310316fd32e4fc8ccf583f4508a28f640402f4"
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
