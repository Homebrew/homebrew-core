class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.52.0.tar.gz"
  sha256 "fccdb5bdb81020442dd0db294d6287eea9f66e989306118713d3bd88431ae94e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46e4acb2644443214cd77dbc7ed8a856a5fcbe114ad64b5cff9a872bc5a927a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cf9d9c64b35311c1c1b2cf1a8d9eeec9aa5428334c1a97c6dc9b96b3d547cfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f1b3dd300a6143613493046bc38042f4a4f5d95b5fc73b01082b84ab42243dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cb426f62d9fc6f063627ff0301b6a3492dc0381b23b586f2b42b5e892d0ca4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "116dd9c4378d2f8a98f432f24447125ebbc2d1003f8f49dd9f32be69e4237728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7702e825eee3a9e96e8b7fb19720f74651c3718c25411562aba22ed3b5a76a3"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
