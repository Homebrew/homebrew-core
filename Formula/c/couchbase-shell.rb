class CouchbaseShell < Formula
  desc "Modern and fun shell for Couchbase Server and Capella"
  homepage "https://couchbase.sh"
  url "https://github.com/couchbaselabs/couchbase-shell/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "7a68af72f0275626f163ac8e200551f73cbd13ac1b91ae0b11e30821857062ad"
  license "Apache-2.0"
  head "https://github.com/couchbaselabs/couchbase-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6f55a754b14e838c418eaf6cdf83f1c26e54385db6a1a926b0c6f5417d413ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e19cc1eb7c4eaca1ef60ceaeda9a292d6c603dc6cb45cdcd9a9b15e65b5a58ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0f42859da70bf41c44fd5c8b70a5ffb27060e723c7506364453bf18f92a8770"
    sha256 cellar: :any_skip_relocation, sonoma:        "1513c71ce31d57c637a2eea18b53cb9b3429806d207c7f1efe0a9a2c822f174f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8a6439bae474f3abd676cd4eb03a856f7d4332962ca1bb2d9c5f0048e9e2e22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "549b48e285b2817cdc5072d35ae976e9d4188ddac47c5d2d9ef180a40fb77ce5"
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
