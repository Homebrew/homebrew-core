class Pixi < Formula
  desc "Package management made easy"
  homepage "https://github.com/prefix-dev/pixi"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "fd163a9a8b85d889d9ed4c2b351eda5ea78b7111c9fc456e166e3fb2e4b10e3d"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10b28fd88a95ee384cf48fbc73068b59d76228f9350c3c1ecbfba871cf8d48d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b869cbb3a7103d911dd0a3899b9819591ec19aa6c4e64a16ba7cbe4cb2fac71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c8cd22ff4b6e3fcb936bdd1b9c1a6815cc5d771cb3aab97c4a631c657003ac1"
    sha256 cellar: :any_skip_relocation, sonoma:         "76abf0131ea3f89ba4d24192f3e8c47ff6cb237a1a915de1f7af7de1acaa7aa7"
    sha256 cellar: :any_skip_relocation, ventura:        "3446136007db6cc846b609ce43a990cf13910437b5d06f9370f974c2061b74ec"
    sha256 cellar: :any_skip_relocation, monterey:       "26b5c4a5ed667cb54eea3e3e7ad998d7640f73e02366a786f6fc1c5997d2510a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9de44848333a75c430478f2192e4d4c6ee06971043bd4297a64c78248a51eaa0"
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
