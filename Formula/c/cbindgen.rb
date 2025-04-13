class Cbindgen < Formula
  desc "Project for generating C bindings from Rust code"
  homepage "https://github.com/mozilla/cbindgen"
  url "https://github.com/mozilla/cbindgen/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "b0ed39dda089cafba583e407183e43de151d2ae9d945d74fb4870db7e4ca858e"
  license "MPL-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0df66e4cab38006433238decb3fe8fd5eaa4a77c76981310e82c1229ee4a8ced"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7f83495c72708ad9815b2e06f663b723f5e0c4e5a20b223cd84769dbe3926b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8dab680300f1ee305201074750750b01c9d52c5f433d060f95bdb370bdd4f872"
    sha256 cellar: :any_skip_relocation, sonoma:        "7be18e30d681d36db517850dbaf464fa075d2241d70b0440c537a2e5ad9eed35"
    sha256 cellar: :any_skip_relocation, ventura:       "7ea8cc561d6dc567fde59dda56db68960fa6c53c4834101771be6126b41cfc3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2be9e6d1272833620392ca72228d40e47fb07e6fe18ea282be05d3e68edb194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdc85b8b19a708a8ab78b4650398ad16c6b4e3faf949a8e2164e9d3eeba70f93"
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
