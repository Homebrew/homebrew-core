class PixiPack < Formula
  desc "Pack and unpack conda environments created with pixi"
  homepage "https://pixi.sh/latest/advanced/production_deployment/#pixi-pack"
  url "https://github.com/quantco/pixi-pack/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "0e56707767a63ebd462bc823b30024b40570c6f91f9e310a4c422c74dbae5364"
  license "BSD-3-Clause"
  head "https://github.com/quantco/pixi-pack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5094eaeeaca0e597ec2640496e34f27c66978f350bf30756d8f930bbb2352866"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "beb9e0d87d8c420a78350ea0940d867ecb35d32cf88aee34351f5c69bb03ef26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d8f6304c09f18e9259e801fe58b7322bd8eca9f1e6b41269e8236bbfcd17268"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec8d7ca35ddf4eec3d09a4226b060982db752c0aeb1e921ea5607487fdf9e95a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32d6b6f1baee029273569d2f97d450d5948f9229a156a2f0a92b7ef0e831d388"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a83f3b85f68fb5da1094d86a22c34a44976b52c6f7d359886688312265447ed"
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
