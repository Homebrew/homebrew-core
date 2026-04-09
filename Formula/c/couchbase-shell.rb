class CouchbaseShell < Formula
  desc "Modern and fun shell for Couchbase Server and Capella"
  homepage "https://couchbase.sh"
  url "https://github.com/couchbaselabs/couchbase-shell/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "d6799eaa9d3e5130163df52ef49f7f588a78bac63b1e78731eb52fa0bd29eb8f"
  license "Apache-2.0"
  head "https://github.com/couchbaselabs/couchbase-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f594c38db7ee6a0a853ea4b07df60ff6d11f21550bbd0f3cf7567393789aedb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22fa2e1e8125d8918e945312c9f71abfab417327f36b75885797d452e02bf3c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "176b49699e3d2dc9abc923cd1262eb6080c8ad71e0c93be32fa406561af9d88d"
    sha256 cellar: :any_skip_relocation, sonoma:        "10c55838e8d6cbc2c24c167a2b12bd506f76423d2be2dcc81fca15cd3b913de3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b73249abaa65a897832a3533057d118a70c2cf44801d7d3bf974a7b977458ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "134d0876c3c49d7b5263d167f66dd3fcd5dcbd017f611b303e6774bd46ebc646"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "homebrew_test", shell_output("#{bin}/cbsh -c '{ foo: 1, bar: homebrew_test} | get bar'")
  end
end
