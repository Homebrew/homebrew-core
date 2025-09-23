class DezoomifyRs < Formula
  desc "Tiled image downloader"
  homepage "https://github.com/lovasoa/dezoomify-rs"
  url "https://github.com/lovasoa/dezoomify-rs/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "539853288768258caac07a559bb7050000e7e0c6e9770227b390c875c26c8ce5"
  license "GPL-3.0-only"
  head "https://github.com/lovasoa/dezoomify-rs.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8be8dcfeec19cf3e8255dfb6b70608f591cfffbdee959919d3d99504558657c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "847cc613f3d55a6e7a4240166c77cb3f96361cdd1aae066d00e81810ea71182e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0404ff601c67f74757b3d827fa0eb15e9a2fbedd0916c827b918cc7b1a5164ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "347c1182e473e74646a95f9a9351149a33ddb84b3eb446da5602bc1091acb379"
    sha256 cellar: :any_skip_relocation, sonoma:        "62bdd4173ad1428c4a19515c4a8ae0728c919e2a7e641a08de9e1105ae72e155"
    sha256 cellar: :any_skip_relocation, ventura:       "0baa5cabf36380e51d8de49217a19b1dbcac4d8699fe15541c098b05d568baeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1533e3d5a7eeef4debd69d4a5b54dc8b38b7dbb03055c93b02699b4651a5c33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a04d863259959bfb3021ba1e553e612e320fb515022081770dad861427ef3907"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "imagemagick" => :test

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"tiles.yaml").write <<~YAML
      url_template: "https://cdn.jsdelivr.net/gh/lovasoa/dezoomify-rs@v2.11.2/testdata/generic/map_{{x}}_{{y}}.jpg"
      x_template: "x * tile_size"
      y_template: "y * tile_size"
      variables:
        - { name: x, from: 0, to: 1 } # Image width, in tiles
        - { name: y, from: 0, to: 1 } # Image height, in tiles
        - { name: tile_size, value: 256 }
      title: "testtile"
    YAML
    (testpath/"testtiles_shasum.txt").write <<~EOS
      d0544af94eac6b418af6824554cb6bbbca8b3772261a1eb5fe9d1afb1eab458b  testtile.png
    EOS
    dezoom_out = shell_output("#{bin}/dezoomify-rs tiles.yaml 2>&1")
    assert_match "Image successfully saved", dezoom_out
    image_dimensions = shell_output("identify -format \"%w×%h\\n\" testtile.png").strip
    assert_equal "512×512", image_dimensions
  end
end
