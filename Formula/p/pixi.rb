class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "b4a109c219775b7a011f0960d88120b2593923181888c50fe1b76f927dd7201c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "864b6cc99dde1926c8eb144ed568e01bfb51eceff5c4987cdca9b0266c8e6658"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7612684373af6c8afb2ee88e51e4fc15c4e02d7eb6acaa335c8157cfce6b542"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8076b810592478f1a1f4dd60815a736000be191bcc3b8c6e9aa6bbeb9782fa53"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cd6e9add7b78e87cca25efc7565fac4f993726e8d394e305b22d6ecb8659b1e"
    sha256 cellar: :any_skip_relocation, ventura:       "24c8d1649a73f049acf54aaba0d6463284ecd48536b5484a3d052ae0ce475263"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03b349dbc3fac33ca249bc25b3b21f4163117abc29d53a2e963638ca8bd9a2e6"
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
