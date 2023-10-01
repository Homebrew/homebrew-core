class Pixi < Formula
  desc "Package management made easy"
  homepage "https://github.com/prefix-dev/pixi"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "8ecc0bd2ed21161f7951242c32c42ad8902913710a81b98b5b5beef2bb357b54"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/pixi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f20656a81a231e23775de8fd73bd7984f73d41be6ffc4dd0f24b3a5d8e24564b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23a4f3965f14fac9a0e9a086df11e4425f1a7a495779e7898068f1772b0a2990"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9de226552e3dcd1d92c95abdd33feb530ab03dad4159f34050e47ddc7214a4bf"
    sha256 cellar: :any_skip_relocation, ventura:        "ef4f342fd7315c20e4fc7ff0782897036ad6ee528647a87a9e3a017981be92bb"
    sha256 cellar: :any_skip_relocation, monterey:       "4c287bf3a424460846c8f3c9f33d3a227da71ab6c6061c33e9c31433c5e0792d"
    sha256 cellar: :any_skip_relocation, big_sur:        "280be3fa85cce7f5a8f0917a878d60bd3d2bac10dd812bc97d4bedf00221aa86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e97c9c381104a3bb09152e8dbe2a3ff663ea0d0d021ff3495827a4fd33f15a59"
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
