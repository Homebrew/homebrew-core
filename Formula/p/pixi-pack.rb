class PixiPack < Formula
  desc "Pack and unpack conda environments created with pixi"
  homepage "https://pixi.sh/latest/advanced/production_deployment/#pixi-pack"
  url "https://github.com/quantco/pixi-pack/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "233e979028fc9c985fbb9b7173aa62f2aafba70b603310c4df9a35c966b00960"
  license "BSD-3-Clause"
  head "https://github.com/quantco/pixi-pack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43f64e648743eb54af014f591c68ace1c21e544704c467238dd96d68614449c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0864407abe500e3cf02eada5c809ac50783c36d92a6b991d43bff0e344b7c86a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ded293e633d2d8b1d98853e93dfebf5c3cfea28b267278d6f3e331aac32a1b46"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0868e3f6c13f8a33a4cc945a9791de4855610d4b84de711ed7ba27a400207bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71347036c41aed03a7f0ecb09e6901a02de4f5696b8f5c4569377ad715495f54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7403f69d5ea93ee22ad7861b4f2de17cbd85e99c056fa37b289f9307040ba9b4"
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
