class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "70e1cddb0ad1f0a32544a973246aecf87393bc10ed8acaec20a7eb5e57cc6581"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "409797afbc960c7f05b28e1ba45cf8a88f07bb3999d0d041bcb7751d583b8977"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44cd6f7de7dcb6850ee09c41a384e1f60cd1f1888de163cf331d39441c442f07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9ae64ea48a437e8a9fc99a7acd8a19753ee3cf02dd093566433f664c4eb3350"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ce65028911e891be7eb03c33c1d8ebefd0cc645f9f68bdef786f448e837db87"
    sha256 cellar: :any_skip_relocation, ventura:        "b0ac8d0af6ec09dba00e5354680fbf5c174f3e9ee0c92c47eceb788c1d9ed897"
    sha256 cellar: :any_skip_relocation, monterey:       "f831e3fcb48ca459c9b57b5c844d233e557d24ea2292b1ca6f8b48c19d30f163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1268600e7e27c2e58a156f375823d5be57cabe8635400432ded1d90a15c53e4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end
