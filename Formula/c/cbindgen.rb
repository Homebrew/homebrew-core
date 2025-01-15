class Cbindgen < Formula
  desc "Project for generating C bindings from Rust code"
  homepage "https://github.com/mozilla/cbindgen"
  url "https://github.com/mozilla/cbindgen/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "af74dd0452ace58895088048873a765fffacc3ad55eea00c0f2999cc4bcf9b5d"
  license "MPL-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a22e2c180c47b277e859d4967a4f032b447c3427c4f3d9c4ced02f0969a34ce8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d07ecac429a68030fcb2c3924a541c086e326eb5cabd4fba4a4772b252d0646"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a6db1176b7a1528189a75c126c77f8d0ac6597adc1e06bcb4e48d4cf2cf16b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6be1b16cb36b35d7bd12dbd59c083f38bee58fda0bda09624010bd2b13d4124"
    sha256 cellar: :any_skip_relocation, ventura:       "598a96f4d0aa79d28b22341bddd873b3e67d6f72d39fcfe39d1b1c2aedbfdf5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb304bf7bbea54486ec6b2945efbf46c226faa3e766aae974a1447bcb5b9482a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "tests"
  end

  test do
    cp pkgshare/"tests/rust/extern.rs", testpath
    output = shell_output("#{bin}/cbindgen extern.rs")
    assert_match "extern int32_t foo()", output
  end
end
