class CouchbaseShell < Formula
  desc "Modern and fun shell for Couchbase Server and Capella"
  homepage "https://couchbase.sh"
  url "https://github.com/couchbaselabs/couchbase-shell/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "404c704f5816c3abd26d460ecbd2e049e45170854948a7219cd9ec41a6fb753c"
  license "Apache-2.0"
  head "https://github.com/couchbaselabs/couchbase-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "658614f1b088002c32486bf1d28a94a98e764c731420def0b32ca6d462f85472"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b7fbbd9244f86b8a2b62e9b66031f6b626458cdd02bf98aa1678da2f6e1f057"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c2a1deb9682f3abf26523e1ee3ee06373cda0070b4d1a40112705fd1a054341"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95b26b103f2e99c9a19dfe8b3362fc387ce561fa56e802fb764eb11882d9c509"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb0a6ecb43eb94f41945d1b51b18c5c0af5d4dbce058ce67f3ee118235884065"
    sha256 cellar: :any_skip_relocation, ventura:        "97c85165badffe574ea33ccc90a1ef50663a43a3113e0dda0430906009df2752"
    sha256 cellar: :any_skip_relocation, monterey:       "b5324717a89c5d0f84710c0c349e2fb0c7c9cfa8ba582c2c7163f9910c0f64de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85e214221dd2de75cbc472660b3ca76f9909be8dc3da77de19d2934030caace9"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "homebrew_test", shell_output("#{bin}/cbsh -c '{ foo: 1, bar: homebrew_test} | get bar'")
  end
end
