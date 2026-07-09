class DezoomifyRs < Formula
  desc "Tiled image downloader"
  homepage "https://dezoomify-rs.ophir.dev"
  url "https://github.com/lovasoa/dezoomify-rs/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "4ccc7ed37f02fe91fddeb8fe58c92707adc7227314e25e2fd17d37fef8605592"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef560398ec91cf8ca8dd0f79ef9cd6d4ffb0006c8df6e51e69c0d19f09829e82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebdcc365bd91b42e310b766742db6ea430e25831cbdea6520f866b4c9a79fece"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d403a000c2115d84ebb84924f5f7f304db8eb663c9e14acd62e11db5e33b1ba5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f508b30c26c8f3f8c437da6a61486ad44d8ed2f22ffd0ed8c591f246af1b6aa5"
    sha256 cellar: :any,                 arm64_linux:   "588d18900d0f56ca60c8476086fcd95f8d15b8e87913666b1fabed9207a47893"
    sha256 cellar: :any,                 x86_64_linux:  "95aba5ec69e8c9b637daef7628316e212c84b3349dd8e1abe9beb5eab75a81cd"
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
