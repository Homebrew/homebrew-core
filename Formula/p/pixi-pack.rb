class PixiPack < Formula
  desc "Pack and unpack conda environments created with pixi"
  homepage "https://pixi.sh/latest/advanced/production_deployment/#pixi-pack"
  url "https://github.com/quantco/pixi-pack/archive/refs/tags/v0.7.10.tar.gz"
  sha256 "21d2a807bbded302130e03483f344672fb4dba322080abb22fc621f8795f5198"
  license "BSD-3-Clause"
  head "https://github.com/quantco/pixi-pack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dc9b22732551966214666ab4ec1180570ff88e90594eadc6feccc7a49fb71d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24e5ae7ba714d0b9c5c3ce8fc7ce087db498189aee93a2ce0f131f43b41e9ab9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ba95a9dbb3724ee5f97ec5d6e6c76f732c095c5950b0e820f627faa0dca5958"
    sha256 cellar: :any_skip_relocation, sonoma:        "83136cd70e606047403c193c39e7e36cecf643601aeb8e1db8e308cc71d245d5"
    sha256 cellar: :any,                 arm64_linux:   "0c4d13e5abd979e2eecb1e075934b3d15611646801065a9fe066350f8b66e8ce"
    sha256 cellar: :any,                 x86_64_linux:  "b1ea8e3484c911b20c7cff1566aa1b5e782365e4ca4b6003c65fbba8056d49f5"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
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
