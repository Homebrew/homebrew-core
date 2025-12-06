class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/refs/tags/cjdns-v22.2.tar.gz"
  sha256 "ac4fb3325a5f55c0f63f5c510e8cfef455b796a627ca19d44b0cc186ccce5b3f"
  license all_of: ["GPL-3.0-or-later", "GPL-2.0-or-later", "BSD-3-Clause", "MIT"]
  head "https://github.com/cjdelisle/cjdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "877bea445c42cb296fcbb50ec773c305993f194232206c340d3a91408adf5100"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "370596b427565d4cb09d8685330416d92a060d8ebc5b611ddef08903788d720d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e7fdd6e878c5bd2dd0e9d562d42b7845a9393b699352ea84d8c03046f82e31e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a5c55ab847e703e36f6d1f57d8134c0196d10f5e74bf52c1e16bf2f51cb4126"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9a2b35ab061add2516b666c58a4c285c59fce20d28a3168d82cef1982866354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7ee9be19ea5c8b824923215442e2df11c89291182dbfd696026f82c41486f61"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libsodium"

  # remove inode check, upstream pr ref, https://github.com/cjdelisle/cjdns/pull/1272
  patch do
    url "https://github.com/cjdelisle/cjdns/commit/4848490a8532c03d9918adf5ee7d28c66eb65fd1.patch?full_index=1"
    sha256 "4eb2abe4d52270018d8a1d1d938ee1323d9b1675f35e36f5c6bf2f0ba50a47e8"
  end

  # patch to use system libsodium, upstream pr ref,https://github.com/cjdelisle/cjdns/pull/1273
  patch do
    url "https://github.com/cjdelisle/cjdns/commit/5ac5ce94028d507041ab4f24d30184b2a8b49c8a.patch?full_index=1"
    sha256 "837f023cd073578282d2cdb217f8c8beece090abad329b1410de6976f56ca734"
  end

  def install
    ENV["SODIUM_USE_PKG_CONFIG"] = "1"
    ENV["NO_TEST"] = "1"

    system "./do"

    bin.install "cjdroute", "cjdnstool"
    man1.install "doc/man/cjdroute.1"
    man5.install "doc/man/cjdroute.conf.5"
  end

  test do
    sample_conf = JSON.parse(shell_output("#{bin}/cjdroute --genconf"))
    assert_equal "NONE", sample_conf["admin"]["password"]

    help_output = shell_output("#{bin}/cjdnstool --help")
    assert_match "cexec", help_output
  end
end
