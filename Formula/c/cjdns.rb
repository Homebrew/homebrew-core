class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/refs/tags/cjdns-v22.4.tar.gz"
  sha256 "27d5083b936144a6903fbb039bc449642ef5ea2c4ea7c3a281779536da79a4bc"
  license all_of: ["GPL-3.0-or-later", "GPL-2.0-or-later", "BSD-3-Clause", "MIT"]
  head "https://github.com/cjdelisle/cjdns.git", branch: "master"

  bottle do
    manifest_sha256 "cad20f12ef491dfb6672065a102a5a332eb704eb7eada314ad96c3ebf64ab82d"
    sha256 cellar: :any, arm64_golden_gate: "b8cdb3cb67888948da9f30fc7223e058afac5ab739ec969ce077ffc607029cef"
    sha256 cellar: :any, arm64_tahoe:       "774d813cfd9bda72a60e8020b07b079535268325bf2398b988df123711e79e95"
    sha256 cellar: :any, arm64_sequoia:     "77742bb6fa01e40c389fc446b220d8751b9b5e99ce9b466ba8c4e2b454e6e0fd"
    sha256 cellar: :any, arm64_linux:       "679678d12b5b46700fc478af0fece0e0c611d182747b5a4844ebe4178628b987"
    sha256 cellar: :any, x86_64_linux:      "3628bba1dd835750f9f78a8964e2dbeeda340b620f83c454ff6a84b334bd152f"
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

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
