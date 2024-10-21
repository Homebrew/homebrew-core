class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "f52246e493203c4069c6390a705043f92c9859d323a27530145bdb19f6f461c6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73187947d17f1115b96b0c98413cf1005d385a01adc1b5d4f933f324ddf174d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a34d836df0246476c2fb61c86a92932add3483ff5279f4fad1f82473c7b45103"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd2ff48c857decb357529b9f20f7b9b4099b95675fe2d04112eb4b9aab300afa"
    sha256 cellar: :any_skip_relocation, sonoma:        "26e6ce3fcbda63f1957d94d48af9a893a28f808b959a8dae418a985ffe3d3603"
    sha256 cellar: :any_skip_relocation, ventura:       "19f67c122050f5e26abcd97b0b75564e4a5e428b60f12a316639b5d00bbdf665"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1796661ceb0cd97385313b4509dbe2e4a8e9b9761979c19c3eb418d993fd464f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["PIXI_SELF_UPDATE_DISABLED_MESSAGE"] = <<~EOS
      `self-update` has been disabled for this build.
      Run `brew upgrade pixi` instead.
    EOS
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip

    system bin/"pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end
