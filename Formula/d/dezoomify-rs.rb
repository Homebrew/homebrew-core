class DezoomifyRs < Formula
  desc "Tiled image downloader"
  homepage "https://github.com/lovasoa/dezoomify-rs"
  url "https://github.com/lovasoa/dezoomify-rs/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "b10bbb08d1e0f135f9db98a264e1b07dc05520b1968f433de2282cd74f004ebc"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6108be976ce125b6bff8f8ac0e3e961d9241c9c516d45ee136cdc1462ce689be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff85552168051685953432ef73daf408f75b248aac71a5823f94cc1ba76f17c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e1400a24bb9c455275a4d7fe2dd522bb6f54bc5e9a1f631fd0290ed657e0e96"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d89fe6376c15244f784963fd9ea1bc5226088978f95c8a47c8eb41da9ac6ef3"
    sha256 cellar: :any_skip_relocation, ventura:       "5088562b5587179e0f31b706a5028a786b1e251dcc33bdce1aa4a1889392ae62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e61cfcc1bc5a27a91b2e77b9c093f772289120c64ddc4f136b69987392efadc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3db821d32bdad848d8d4241afec374f212cf335fce3320831313faf90de84b4"
  end

  depends_on "rust" => :build
  depends_on "imagemagick" => :test

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
    dezoom_out = shell_output("#{bin}/dezoomify-rs tiles.yaml 2> /dev/null")
    assert_match "Image successfully saved", dezoom_out
    image_dimensions = shell_output("identify -format \"%w×%h\\n\" testtile.png").strip
    assert_equal "512×512", image_dimensions
  end
end
