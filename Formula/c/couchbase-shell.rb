class CouchbaseShell < Formula
  desc "Modern and fun shell for Couchbase Server and Capella"
  homepage "https://couchbase.sh"
  url "https://github.com/couchbaselabs/couchbase-shell/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "2679e5e2655ea0744efe66cce665481d95676ef26d284ea0341311068ccfb972"
  license "Apache-2.0"
  head "https://github.com/couchbaselabs/couchbase-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "decf67dd604aa1e82b3bb6cf51ec528cd6f840efb2887c613c1050daf01daa85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e4207cdae2d36437ad70fed865a844849ade6670facd075383a78a8152e8726"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baeb1763d305776f71ac2519a2504f5904c4b166eca40f59dd2f6a5c4df1bb93"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99354510fd9b1979a7da10ef2c67b282b0b029aca9450e3bbb8e1f2fca08801f"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf75c7a65c8cddad02ca437e145f899dfae38e471df20f709f1119109a74b3c5"
    sha256 cellar: :any_skip_relocation, ventura:       "a379e347f9b4325c6521cb7e30b24f122b3738324e013ea77d224eaf3df56dcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1789ab9a9d879369b2f7942f59ff171b8fa197f9c1f95029ff5914895cfc4ddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfbddc03319d40472bdae18473f650e51a29c68b9e2574a58b36f363f43faca0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
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
