class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.4.9.tar.gz"
  sha256 "0c59cc6e9055f71b5b8dc14196208e359412569d340275c9afd4b5c9ef965847"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bbcc438c043cb9429dd159ba6247e6c07f00a6a72c5bcb02cb8484c9ac0e6ed2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1f7d60f1041ed8309ea73f87f4f95a0a3157473c7c9e269558b8140acf8b815"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed87a674a72e7e3f36a29a0385ea7735feb4cb1c8e5515a611bdfec7cf160224"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1bc3767013b42542174aa799ae05ccd57a082128ffb7f4feb4046f729289d9d"
    sha256 cellar: :any_skip_relocation, ventura:        "397dd4db7176fe7574d3b36dd21857c2c2c80b79415303a8ecb867c068d1e148"
    sha256 cellar: :any_skip_relocation, monterey:       "75f4d272e2de71f952b3e988449b34c6d9fe030985d67d422c70dcbb89148fe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7205eb4623d488142e5f02a5587197a21e66d4a4dd7cba6903560bebf27a9286"
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
