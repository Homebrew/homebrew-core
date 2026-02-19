class CouchbaseShell < Formula
  desc "Modern and fun shell for Couchbase Server and Capella"
  homepage "https://couchbase.sh"
  url "https://github.com/couchbaselabs/couchbase-shell/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "2679e5e2655ea0744efe66cce665481d95676ef26d284ea0341311068ccfb972"
  license "Apache-2.0"
  head "https://github.com/couchbaselabs/couchbase-shell.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "977f11ee4b592d21b686acc1b1f944ccc489a5880fcea647692ff54c65596ff7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e77f30aea33590c635f0e616d8c1be503015152ebcf627d71e123d7b8e2fc49b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e42479455532b58a4e19a483ce3281a13394d13fb8d9d5cca32a0cc0753082b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f2fb928c3cf68b02d379a4525096bb20a901033ab1f0521256b6ee35d8fbcba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e204136d8f0f757dadf3e5c3856fdedd0c77d5a6367596f171491094b307bc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5dee81dbd8b43cbe658722db7d7b981dbf109759ef30a34a546da8ab2ea085d"
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
