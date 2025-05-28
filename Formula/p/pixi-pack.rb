class PixiPack < Formula
  desc "Pack and unpack conda environments created with pixi"
  homepage "https://pixi.sh/latest/advanced/production_deployment/#pixi-pack"
  url "https://github.com/quantco/pixi-pack/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "3ac701432aa850d27f5e02656f740f9710b39df41c9196b9c60ac2599d322982"
  license "BSD-3-Clause"
  head "https://github.com/quantco/pixi-pack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6070d28ff2c0954c5283f6867c2f68643ffb401b2b00a1807a01498a6bea8e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32b85775ec9d1fee721915f2e03d60274b346d01d3ff1f9191c98395263bff2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59b785abf4358b18b5d7ca7ce66050131fe9251e984d9a7ca691184952f4d1f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4d33fd816d968c23dd2ebd6d6ac79a86a0544893a5503e8bebffc2baf32e8ee"
    sha256 cellar: :any_skip_relocation, ventura:       "fd303579bc7c0188427a95861424cf7a57e6ed6455211ac7973f2871fb228ac9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6853346d552d0ebc0977f1eaae6d3d711d96490293bc961a3ff70938c735e731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b94ca93de845143eecce6318c1f8eac285b2183c08b8268a212741ae2c1eb8b"
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

    generate_completions_from_executable(bin/"pixi-pack", "completion", "-s")
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
