class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "1a64f7b61126c3e69c63fd390ac4de2fa42a79970e04f756b0c2e5b8fc76ef59"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "deebd03556bd90f37e3dc5306b781cc00a7c034dddec2aa801b899952531c920"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a7247ce868c68f1603aff3d898e0219ded040f6cae9b02eace957f6f069820a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c3bfc577cf46bfb01ebf8478501c7fbf2846b1e3c8a1f08fffeba25d2dd2229"
    sha256 cellar: :any_skip_relocation, sonoma:         "43888125218fec58171b4d189474ef434ea3f4dde4034109b8d2d17391c8e954"
    sha256 cellar: :any_skip_relocation, ventura:        "429d79141948cb03089316c02753a1ce2918337bc7b53091621d309df0718a9d"
    sha256 cellar: :any_skip_relocation, monterey:       "c6410e60fe3d7e98ff5fdba1abb32c5d3fcdda4df35c8bd062af8a8cd9cb7ab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef10d208e551862e74cca85cf6d98916e9858b90d124411706143c686d2c4f6a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip

    system bin/"pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end
