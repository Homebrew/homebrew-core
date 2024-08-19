class DezoomifyRs < Formula
  desc "Tiled image downloader"
  homepage "https://github.com/lovasoa/dezoomify-rs"
  url "https://github.com/lovasoa/dezoomify-rs/archive/refs/tags/v2.12.4.tar.gz"
  sha256 "e566a0d3b5ca0d43d854fe61d4179c5a0e00df7ee30db8e433794c587a3007f7"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3118a987327d95b5ef945fbaf4c598f527133daffcbb165d9609c5df68626fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6c4fcdacb5bb1864ae2cc532fe2e6e1c79b15f884f345c41a8279c579a7ab0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d739c78b279a15b59e2ffd3a91bd607108d108361fa8b6b16b768a0a49df1d3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "1dee73796118840791f484564ff0a87dcddbd4f5c56286386de070340339fa1e"
    sha256 cellar: :any_skip_relocation, ventura:        "f4b2ed19f87eba205a9144af8462aadf493f4fcf16e056ce61ffa1f79be48dd9"
    sha256 cellar: :any_skip_relocation, monterey:       "5043e61b079f4e06dfa2b8a641b9c0819c34c34f4d2cd02d38286bdb0b39936f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4288d4e6263d330a6858a1871e4323ec2879afd1fa03ccc6202dc6f92d04e91a"
  end

  depends_on "rust" => :build
  depends_on "imagemagick" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"tiles.yaml").write <<~EOS
      url_template: "https://cdn.jsdelivr.net/gh/lovasoa/dezoomify-rs@v2.11.2/testdata/generic/map_{{x}}_{{y}}.jpg"
      x_template: "x * tile_size"
      y_template: "y * tile_size"
      variables:
        - { name: x, from: 0, to: 1 } # Image width, in tiles
        - { name: y, from: 0, to: 1 } # Image height, in tiles
        - { name: tile_size, value: 256 }
      title: "testtile"
    EOS
    (testpath/"testtiles_shasum.txt").write <<~EOS
      d0544af94eac6b418af6824554cb6bbbca8b3772261a1eb5fe9d1afb1eab458b  testtile.png
    EOS
    dezoom_out = shell_output("#{bin}/dezoomify-rs tiles.yaml 2> /dev/null")
    assert_match "Image successfully saved", dezoom_out
    image_dimensions = shell_output("identify -format \"%w×%h\\n\" testtile.png").strip
    assert_equal "512×512", image_dimensions
  end
end
