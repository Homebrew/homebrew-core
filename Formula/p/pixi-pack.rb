class PixiPack < Formula
  desc "Pack and unpack conda environments created with pixi"
  homepage "https://pixi.sh/latest/advanced/production_deployment/#pixi-pack"
  url "https://github.com/quantco/pixi-pack/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "04d1b428b988fb0aacf95da758cde53b6621930140a28211540013187e663087"
  license "BSD-3-Clause"
  head "https://github.com/quantco/pixi-pack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8c379963b73df82ab17b7819bbcd6d780e1e831050a2486cc9e5880f83320f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "206528a0aa504db5fe2973ac9869572bcff0386caa6e767aa8fabd141f757d97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef0a4afe18354d4bdd03e98eea8ba940e781fd7319be44986b8178cce942d0e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "511896dffa5a4957f6ed8c03747056055ff5cdd1f89dfe704ec7d42ec6390297"
    sha256 cellar: :any_skip_relocation, ventura:       "6f712db1c652a58340330bc2dd1956f00babca2db4c5b09ec6ec565388ffd1ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b183d13e8c1cd08f11df4046ba31cf56bf29c7ea4448ff934a1055f0219f54be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6461873db821ef2fd5964dc42fff7ce02a069a135cbb57f6623eb4ba62269df0"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "pixi-pack #{version}", shell_output("#{bin}/pixi-pack --version").strip

    (testpath/"pixi.lock").write <<~YAML
      version: 6
      environments:
        default:
          channels:
          - url: https://conda.anaconda.org/conda-forge/
          packages:
            linux-64:
            - conda: https://conda.anaconda.org/conda-forge/linux-64/ca-certificates-2024.8.30-hbcca054_0.conda
      packages:
      - conda: https://conda.anaconda.org/conda-forge/linux-64/ca-certificates-2024.8.30-hbcca054_0.conda
        sha256: afee721baa6d988e27fef1832f68d6f32ac8cc99cdf6015732224c2841a09cea
        md5: c27d1c142233b5bc9ca570c6e2e0c244
        arch: x86_64
        platform: linux
        license: ISC
        size: 159003
        timestamp: 1725018903918
    YAML

    (testpath/"pixi.toml").write <<~TOML
      [project]
      name = "test"
      version = "0.1.0"
    TOML

    system bin/"pixi-pack", "pack", "--platform", "linux-64"
    assert_path_exists testpath/"environment.tar"
  end
end
