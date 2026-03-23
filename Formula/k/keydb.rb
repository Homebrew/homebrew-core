class Keydb < Formula
  desc "Multithreaded fork of Redis"
  homepage "https://keydb.dev"
  url "https://github.com/Snapchat/KeyDB/archive/refs/tags/v6.3.4.tar.gz"
  sha256 "229190b251f921e05aff7b0d2f04b5676c198131e2abbec1e2cfb2e61215e2f3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "25bf74a3cd05a239a9669273f30390c270c43671284060048f01361c7c008a35"
    sha256 cellar: :any,                 arm64_sequoia:  "40b960924a1ec659a01d19cdbc55a99b1f9f25c12920394f4406f602bf364544"
    sha256 cellar: :any,                 arm64_sonoma:   "38437979dd3b609815380178028c57880e4e7c4e743aadd5da7721aef2502d3a"
    sha256 cellar: :any,                 arm64_ventura:  "010db9d77cfd61aa2195db11eb21e7e30be2b565a2b92c837c69c82bd325a237"
    sha256 cellar: :any,                 arm64_monterey: "eefed6df2c14cfbab28ac8ce65f888d011bed8a1edec7095b891ba2b418ea733"
    sha256 cellar: :any,                 sonoma:         "9c96a66a65ad45e31aded15e6a4306d1fc4c97d707a060a3c31bba357310449c"
    sha256 cellar: :any,                 ventura:        "0b94cbbcf2ba980719309b3545c5b63fa7328f3067d66dc8686e6db64a13a745"
    sha256 cellar: :any,                 monterey:       "ca35b258a5ae50f171e31795616d4fb569a40ae72c12566b511b4442ff91de8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a30afa2a2f443a1ca41ce65f95f7b5e0db62d12c8048f200dbfbe58324a554f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66f4992328aeaa000bb75107076cb9d05eb8b3ce229e94a51262d33d853af1b7"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "curl"

  on_linux do
    depends_on "util-linux"
  end

  # Backport fixes for ARM Sonoma
  patch do
    url "https://github.com/Snapchat/KeyDB/commit/674d9fb7eea1e6cca6ac8da3b2d1a63dc38c9d2b.patch?full_index=1"
    sha256 "aa175e61c8a8b5c12f8608afdb20985a558c14cc94f69be43ab3e0e0c999a3bc"
  end
  patch do
    url "https://github.com/Snapchat/KeyDB/commit/603ebb27fb82a27fb98b0feb6749b0f7661a1c4b.patch?full_index=1"
    sha256 "3cece0a51cc74606bcfa32f1b745b615078be5c67ba3e97287ce9c5c982c1ba7"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/keydb-server --test-memory 2")
    assert_match "Your memory passed this test", output
  end
end
