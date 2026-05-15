class Cbindgen < Formula
  desc "Project for generating C bindings from Rust code"
  homepage "https://github.com/mozilla/cbindgen"
  url "https://github.com/mozilla/cbindgen/archive/refs/tags/v0.29.2.tar.gz"
  sha256 "c7d4d610482390c70e471a5682de714967e187ed2f92f2237c317a484a8c7e3a"
  license "MPL-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b22a6b4dd3a6df2cdf179c40bc3e08c0c1dca9d94e1b580fed97be80e59ebca4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b51a913215b88a509297cb8b67e59cd31aaf5a30548587eb0bc34e3a9efe5b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17eb4bea606ccb824b116a5612cd9865837dfa4f73b7f7f6809e0a1a126d0953"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5f5b6e4ea72818d31b666c4809121e7ecdcade7a441c6b8ed190c7aa240cff9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c87b333343a4627059eb5f7d0e771976b9361fc6ba9bc20d96083b333a32a527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d8e06847e23798a81461f36c09b887c5734ff67591a8abaa3e0cb444ced62b3"
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
