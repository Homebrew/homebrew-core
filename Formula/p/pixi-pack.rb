class PixiPack < Formula
  desc "Pack and unpack conda environments created with pixi"
  homepage "https://github.com/quantco/pixi-pack"
  url "https://github.com/quantco/pixi-pack/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "d0c6eb4d20747a5ea47093dc06e80e15a46ec3fd9c3c1e93ee035480e3b0a75a"
  license "BSD-3-Clause"
  head "https://github.com/quantco/pixi-pack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c92b366fcc6817e56e3e59ef867cd001aef2d2778399a8ed8fe1b92b3d75c26a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3aac9b6f567d34050e684c236dfffb8e9b073c7bfa764d6ba603997f6cb11d73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2243e0179886c73fa74939ee0a16982d6595806dfd3a0208696a04a8c871b305"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea582b6d7cd63c5ae192b6e969858d122fb2d534be58ebe53f7d78ac65396b1e"
    sha256 cellar: :any_skip_relocation, ventura:       "4581a3e8a26d8230ff5ae74889d3579df25f5591785dd5a54cef11113e747947"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a73baa4e8a18e3d24c190fe3462a3eee06970ec109b1d1cca1931a381e067b1"
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
    system bin/"pixi-pack", "pack", "--platform", "linux-64"
    assert_path_exists testpath/"environment.tar"
  end
end
