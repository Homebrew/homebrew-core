class Cbindgen < Formula
  desc "Project for generating C bindings from Rust code"
  homepage "https://github.com/mozilla/cbindgen"
  url "https://github.com/mozilla/cbindgen/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "6697f449d4a15d814d991249a611af961c97e36d9344c7ced6df35c5c25b40cc"
  license "MPL-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8216edac1c20fb2c910c259c6116838c3abf45f7b9a75b9ce4fcbf8ac74fa859"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33ebcfa85a68f3fbb5049b341f8a71e98cd1bbd830082c6096f19077a54c7990"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be04333695da79e4b6818b529ee29abeb7fbe23924e4a1fc4e330896197c0e13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "352e74bc4454633c52d51bb110f3d5fdfd11a903c53f212b3c30a882856d350c"
    sha256 cellar: :any_skip_relocation, sonoma:        "822ffd8c1587adf873984e6920d3f049f0d647c84b24544dd3375baf60997c00"
    sha256 cellar: :any_skip_relocation, ventura:       "57d6a07db7d0c3d5cf9f3969dc8e9b69b5d666adaf32c40b4a85246d52ba5257"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bb26820809e7148dd6910c040dbdbda13d1eb7f7accf5bdc28bb86db7b278c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "140899590bd0b5406efefecd35f9a34915cf8a3a2683e54e9a06bace887d152a"
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
