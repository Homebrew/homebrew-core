class DezoomifyRs < Formula
  desc "Tiled image downloader"
  homepage "https://github.com/lovasoa/dezoomify-rs"
  url "https://github.com/lovasoa/dezoomify-rs/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "cf896da035dd0e5f59f20f506d343f5fad9fa2102f69ae75ca092d98dfdd7ed5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11b977ac8a4e6d9fa5ebe7d43678bd305970fcc9d70043d16c25264cbe96adf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de332846b0bf1796c2e3df40eb28b75722d9f1214438609e9fccd06b556388c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eba14efdc8f4c9c06bce7534c68524b2c9625472670fe99917e92dd2d9fb4aa5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a483599af8e36b38cca3b5cce33e816141fa5e9dd380fc067b1410a631e57b8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7ea14fb198139f5d2fa9879cc183e16538c2b6669885ee1600be6a552f26cdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50f5b73624ab915ddc1695bb0ca83c1ef9dc953a338feff2ce169a2e5a588e6a"
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
