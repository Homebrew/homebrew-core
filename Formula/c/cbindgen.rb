class Cbindgen < Formula
  desc "Project for generating C bindings from Rust code"
  homepage "https://github.com/mozilla/cbindgen"
  url "https://github.com/mozilla/cbindgen/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "b45e1a64875b615702a86ac3084ef69ae32926241cd2b687a30c12474be15105"
  license "MPL-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "20e50834cf9bedcded966bc6c6e60486d79f3480b689314fbf7a7101fce55ee8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1cf824d4724dccd013815867348ec646e821df5a7f868e2310afdb65be543af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecfa0bec5c75d0d5825976fcd6e553dbad08ee0121cd6d4269be6acf0174c6da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4baaec615fbb17f470d2634a326545a8bf4cb632f0a8e6bebec009413c132215"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1dc5f3936dca28bac0ed165764cff643713d8e1e5950935c99d7d1d51178532c"
    sha256 cellar: :any_skip_relocation, sonoma:         "9810e3153d17d297f4ec84fc83d3e1b2b7c14a5d3025b80ed3e41c97d239464e"
    sha256 cellar: :any_skip_relocation, ventura:        "34882ce72bfe4c66e03f532ff551f31b7db581e2202eeaa3487e162b39ff1d1d"
    sha256 cellar: :any_skip_relocation, monterey:       "c703d487fad25bd3691ec779a23d5290e6fe18ebe69737d0ac0166c75e4bafe9"
    sha256 cellar: :any_skip_relocation, big_sur:        "289c9451cb7462239c23bfe996a36f5ee19f30be40f99527a0fe3b08b596c356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93a1a09a5301c915d7c0b81068b9ce4aefa8873becb9e1aaef8e99d6a0d476e1"
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
