class PixiPack < Formula
  desc "Pack and unpack conda environments created with pixi"
  homepage "https://pixi.sh/latest/advanced/production_deployment/#pixi-pack"
  url "https://github.com/quantco/pixi-pack/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "b43c2e227e265e5ff7436e8ec7a6be1df85931cc85a0b4a717be6c26c2760305"
  license "BSD-3-Clause"
  head "https://github.com/quantco/pixi-pack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7aed6ef2a54dc1fe2657bcd8ffe50ef2a84c4f2d6600add31773a549683f45df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6445360dd2f9b6aa00fc44b47d98b2f85b55fbc32dfe4529cff48819130c4e15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4faea5fff4fdcb650859d8401131d75e03a6a201cd0e55c42482bff27119089f"
    sha256 cellar: :any_skip_relocation, sonoma:        "92dc3faa6139f4c53b391872a56ffbcadb37e935c4130b78fb9336b91a3191bc"
    sha256 cellar: :any_skip_relocation, ventura:       "2593d3e4df6e4ce837c4863b08aa59ff76966ded5c601192798080fe9f4040db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f318b3add8215af33b50cef27eadbc95c61d5b7b5b0f8930cdec8afa2a24ff4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d6b95356e2b2c51e3012731f6f036c58c14858df71cbb734c566d92817fbf1e"
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
