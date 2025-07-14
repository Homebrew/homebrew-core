class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https://github.com/anistark/feluda"
  url "https://github.com/anistark/feluda/archive/refs/tags/1.8.5.tar.gz"
  sha256 "9e86ac73fe7aaada534992523b4f0a2ea7bbe44d5e89d0eec9dd898f77101bb4"
  license "MIT"
  head "https://github.com/anistark/feluda.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7e5d5ffe04a61b5a2be726c0d33955b4dd396ac079ac51c53989cf66bf158551"
    sha256 cellar: :any,                 arm64_sonoma:  "2684a98b4166644cce073427df959de870322677951f169dc2c9177682d1df6f"
    sha256 cellar: :any,                 arm64_ventura: "22c15356dc7fbb1d50a015b638d0cca1db7846fc5b1d1c38c521b9af82bb3b38"
    sha256 cellar: :any,                 sonoma:        "bcedc4844a1b9de4cfecf625d055793aab33a80b4a9f627d31a2c71691e5a378"
    sha256 cellar: :any,                 ventura:       "758820c3d717503668641fc5964c96df74b26abdb768915652a7b7eae28e2f27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94c6a7bc2d8ac6628b86135a34498611ce1f5db541dfdda687ce3c1c1e3f66a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d6dc544d9ad47de8fc92e360870a417ed62adb69bc228f3ac7b7c2c74e9f06e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feluda --version")

    output = shell_output("#{bin}/feluda --path #{testpath}")
    assert_match " All dependencies passed the license check!", output
  end
end
