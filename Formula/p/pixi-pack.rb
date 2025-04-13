class PixiPack < Formula
  desc "Pack and unpack conda environments created with pixi"
  homepage "https://pixi.sh/latest/advanced/production_deployment/#pixi-pack"
  url "https://github.com/quantco/pixi-pack/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "70dcc987659e1ceb211e5ee30a26d7305c37817cd92a0cc1c604f6040d03fe28"
  license "BSD-3-Clause"
  head "https://github.com/quantco/pixi-pack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "827ec44598dafbcc769ec5d030fc69f2c5a4447aa58c433ad4907c33af7a7ba2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92508c00ef681fb2d2ec5bb3f7417bbb323e03db07652294cbcaea65423f4e36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a509e6961de54b209b8984945d25a14d7fb4613b0100a9d70738c880262e93a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bdecea970bdeb5a2749edeecfcde2dcd61774b1d4f7a1661595e2c7415a3417"
    sha256 cellar: :any_skip_relocation, ventura:       "7e2734c18903e3b3936d747f40b5061d8bc03004ea4753a0661da344dafc7fd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "409f370dd360ffd65c88018106100f4f5e6d9123a5781e055d3e428703ea8eb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9af2851b08b0b18c0f492cf0fa35c9a8b9119a04754858c879c8e72333a59b8c"
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
