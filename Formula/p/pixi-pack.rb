class PixiPack < Formula
  desc "Pack and unpack conda environments created with pixi"
  homepage "https://pixi.sh/latest/advanced/production_deployment/#pixi-pack"
  url "https://github.com/quantco/pixi-pack/archive/refs/tags/v0.7.9.tar.gz"
  sha256 "d70c7d58730a104e0a7dfc4d5cf7afea5022a8707ceaeeb820595d43678e8155"
  license "BSD-3-Clause"
  head "https://github.com/quantco/pixi-pack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1e55363a9e3fdabdbf464a1fbfa22a6ea67ea75475c5c31b643207ae7cd5602"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8c994357b9dd9d3b2a9a21f1b4e023402b243bec2f9f15a0a435a32f5071129"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3661808148ac11b767932c459781b34ad0da0ef57c02473cc77187667c6f1882"
    sha256 cellar: :any_skip_relocation, sonoma:        "039240461813aadc7b66067ea929bf487d3608920eede0e5e84b70bf24ff4ab0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54eac6cbcf76de47dc0a0967e0aaedf8ca3b4435345eb7749ac64791f8b5330e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c63d857a89251dff5a3b7cfd745657c2887db2688357290392ab1c151502968"
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
