class Cbindgen < Formula
  desc "Project for generating C bindings from Rust code"
  homepage "https://github.com/mozilla/cbindgen"
  url "https://github.com/mozilla/cbindgen/archive/refs/tags/v0.29.4.tar.gz"
  sha256 "9b5757e915cf8be523d3aca282b9b5651bafa112e14bf1ba488562ba282807d6"
  license "MPL-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4f59ce0836d22eb62d3b7719cfbac095adbce295446a882edf8f59ebeacf193"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5048be0ae465821094e3eb1d8e56761e7b590e8f329ecbdafb9f2e1cbe8d1325"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39eb22ac69807fc5a7ef7f27f19b81b1d3d1a283db9cf9cc9ed2d0f317297cbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "d54e448595267dbf5d2a179007087837755d962e8fa8806fd9b28c49088c1981"
    sha256 cellar: :any,                 arm64_linux:   "01e51ad2b3ada44fb800c5000601d6a2ef9f83e3f14e5d9dc4426264d13be56b"
    sha256 cellar: :any,                 x86_64_linux:  "25fa494385b01252e26b2c47b9d874ca7bdaedd757c2ece19dafee5c135b59c4"
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
