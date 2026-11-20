class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/refs/tags/cjdns-v22.4.tar.gz"
  sha256 "27d5083b936144a6903fbb039bc449642ef5ea2c4ea7c3a281779536da79a4bc"
  license all_of: ["GPL-3.0-or-later", "GPL-2.0-or-later", "BSD-3-Clause", "MIT"]
  head "https://github.com/cjdelisle/cjdns.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "2c5acff39fa600723fd9e528d6db61053ab7886981d3f0e8a72b837cace88318"
    sha256 cellar: :any,                 arm64_tahoe:       "3e80901cd150c0a4985cc8ec0c94b1241716a80d4765f87d4298bcef556a3a0c"
    sha256 cellar: :any,                 arm64_sequoia:     "59d19ffb7e8297bb316e1ad8b1bcbe0d26c8f3be65c8cdec2b7ac3a11b2e5008"
    sha256 cellar: :any,                 arm64_sonoma:      "f9dba69b82d805f37555fc9059f9963cdcc8cd79a5272df7ddc8b882ad03a5b6"
    sha256 cellar: :any,                 sonoma:            "faca4c08e507600ff631b2f06387de220a74cf3b74ce53759e4ba86171509a87"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "859d70d081723d20c26072e75c5040c23848e7555ec84ae1df094a150522167a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c843f89da788dd4cf98f419584f680e76ee0b81b1b819fd474569c9389e43360"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libsodium"

  # patch to use system libsodium
  patch do
    url "https://github.com/cjdelisle/cjdns/commit/5ac5ce94028d507041ab4f24d30184b2a8b49c8a.patch?full_index=1"
    sha256 "837f023cd073578282d2cdb217f8c8beece090abad329b1410de6976f56ca734"
    type :unofficial
    resolves "https://github.com/cjdelisle/cjdns/pull/1273"
  end

  def install
    ENV["SODIUM_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", "--bin", "cjdroute", *std_cargo_args(path: "rust/cjdns_sys")
    system "cargo", "install", *std_cargo_args(path: "rust/cjdnstool")
    man1.install "doc/man/cjdroute.1"
    man5.install "doc/man/cjdroute.conf.5"
  end

  test do
    sample_conf = JSON.parse(shell_output("#{bin}/cjdroute --genconf"), allow_comments: true)
    assert_equal "NONE", sample_conf["admin"]["password"]

    help_output = shell_output("#{bin}/cjdnstool --help")
    assert_match "cexec", help_output
  end
end
