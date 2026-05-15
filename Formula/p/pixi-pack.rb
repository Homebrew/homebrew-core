class PixiPack < Formula
  desc "Pack and unpack conda environments created with pixi"
  homepage "https://pixi.sh/latest/advanced/production_deployment/#pixi-pack"
  url "https://github.com/quantco/pixi-pack/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "8ee25c37aa37c54a0d8f2b3d1f1e98d4ea683d1ea7a9dcc8452ef7c7c9b8f781"
  license "BSD-3-Clause"
  head "https://github.com/quantco/pixi-pack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e62140318018329b762d1e8e38480f32a1ff55fd4dbc89d8c040efe08679731"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "434261db92706aa195dd4fa925d4d45ecc4ab415bdaaaa0203447c7e5ff00f6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3e966246a06d0e6961381132374df1606f843dc4e01340cb4184e6a62ec0e5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "04adb6f1425f2294eeb881dfee9ad47a43078e126e1dca8ae0f033023076442d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1d51f9b68046799b95ffd7cd6363b3b199588f438e09a9a4b58224fe4fec059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f41e33d702e8716da52137138267fe396da0cc425fe5bdd662421c7532cb37b2"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pixi-pack", "completion", "-s")
    generate_completions_from_executable(bin/"pixi-unpack", "completion", "-s")
  end

  test do
    assert_equal "pixi-pack #{version}", shell_output("#{bin}/pixi-pack --version").strip
    assert_equal "pixi-unpack #{version}", shell_output("#{bin}/pixi-unpack --version").strip

    (testpath/"pixi.lock").write <<~YAML
      version: 6
      environments:
        default:
          channels:
          - url: https://conda.anaconda.org/conda-forge/
          packages:
            linux-64:
            - conda: https://conda.anaconda.org/conda-forge/noarch/ca-certificates-2025.6.15-hbd8a1cb_0.conda
            linux-aarch64:
            - conda: https://conda.anaconda.org/conda-forge/noarch/ca-certificates-2025.6.15-hbd8a1cb_0.conda
            osx-64:
            - conda: https://conda.anaconda.org/conda-forge/noarch/ca-certificates-2025.6.15-hbd8a1cb_0.conda
            osx-arm64:
            - conda: https://conda.anaconda.org/conda-forge/noarch/ca-certificates-2025.6.15-hbd8a1cb_0.conda
      packages:
      - conda: https://conda.anaconda.org/conda-forge/noarch/ca-certificates-2025.6.15-hbd8a1cb_0.conda
        sha256: 7cfec9804c84844ea544d98bda1d9121672b66ff7149141b8415ca42dfcd44f6
        md5: 72525f07d72806e3b639ad4504c30ce5
        depends:
        - __unix
        license: ISC
        size: 151069
        timestamp: 1749990087500
    YAML

    (testpath/"pixi.toml").write <<~TOML
      [project]
      name = "test"
      version = "0.1.0"
    TOML

    system bin/"pixi-pack"
    assert_path_exists testpath/"environment.tar"
    system bin/"pixi-unpack", "environment.tar"
    assert_path_exists testpath/"env"
    assert_path_exists testpath/"activate.sh"
  end
end
