class CouchbaseShell < Formula
  desc "Modern and fun shell for Couchbase Server and Capella"
  homepage "https://couchbase.sh"
  url "https://github.com/couchbaselabs/couchbase-shell/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "9300027b9d9d20904ed0306e5a7fe745f3bba8519d17e0f743cab52f3c574fa9"
  license "Apache-2.0"
  head "https://github.com/couchbaselabs/couchbase-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "331ac39bc579b4900209815f6433984fe7c83062f9a0b12f6e3e6047ef2fc3bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77ce502e16ded63a93445bfc29702db5cc4048bef9a7456795af2b9b818b877a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "706a31564ff52d58a39e5c026e1209690bafb2ca9381914df2f4720ac97df974"
    sha256 cellar: :any_skip_relocation, sonoma:        "456b7c807877cc30ec96e16019a21605038a9a10c0e45432fbfe114a944feecb"
    sha256 cellar: :any,                 arm64_linux:   "02e0ed0acebea23aeb20ff8aca51d2814a7eb3b5b2caf94daf4bfe0207921d6a"
    sha256 cellar: :any,                 x86_64_linux:  "d7078dcd79f88628a0ff08fa4b2b3796cb5ffc990641544c2ba180487c5c8bc9"
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
