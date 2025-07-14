class PixiPack < Formula
  desc "Pack and unpack conda environments created with pixi"
  homepage "https://pixi.sh/latest/advanced/production_deployment/#pixi-pack"
  url "https://github.com/quantco/pixi-pack/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "dd21e229a3949b7f620687986f3ae21d7fe323110e1c579c995d3e1f4f530a0e"
  license "BSD-3-Clause"
  head "https://github.com/quantco/pixi-pack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52f04d5b33ffea2ad2d7df79874e8f3b65a2a64f48d310e1449d95bcdb1aafb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5651a45c5277a39d9be48806741b51bd8038da302c08217107568aae278fb36e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1aae4fed2b8494a960c0cf939d092fc02dece67987d72f1ba4af846171070dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "810a57d6e1ff4b0ff7cb98c2af8c6bead8a78a47e230bd20f21cfbef2220e009"
    sha256 cellar: :any_skip_relocation, ventura:       "565b0cdb6d183b9836a1cff9d77db7f46a7c3ebe1229ffcfc5b04dca50be789a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dab9ab5e24acf46655b5c974dd7459434d1936440012ddfa21b7b5e8561b315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc1646d07154a511ceaa0c057689f91e8f2eed6027b3ea3924482cb5a307c2df"
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
