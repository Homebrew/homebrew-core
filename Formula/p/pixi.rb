class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "8a3e249c00a4182bab311880f48d449c01efb7163b825b27fbc084838976219b"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/pixi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cdd9eee7af2ad114f5ebdf653516b478162f440fabe5c780efbe2c5b3886ed3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fed79b1afbc1daa5ec05a689b9b186156694af2fe1b4439571eebbd8bfd2c2aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1eab64de456f9ede2a4890288b9c7662e8819ef723360771922b1f3b2e78b2d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "56f5111affccad7d0dcb8a113995e46c01e401174191d3ecf9fdf86529a4d721"
    sha256 cellar: :any_skip_relocation, ventura:        "5b807001887f2b5ed037889b1b79335b7b0e45114197406788626dae5b64164e"
    sha256 cellar: :any_skip_relocation, monterey:       "b9367734f8b77cbc9ed8969cd6dd796674ecb4cfbd37d7033060421d105740d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "295e602c51acc5a904084fdf34258e2afe7bbbb3943916836366ef766aba93f7"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip
    system "#{bin}/pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end
