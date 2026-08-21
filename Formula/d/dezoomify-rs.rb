class DezoomifyRs < Formula
  desc "Tiled image downloader"
  homepage "https://dezoomify-rs.ophir.dev"
  url "https://github.com/lovasoa/dezoomify-rs/archive/refs/tags/v2.18.1.tar.gz"
  sha256 "35c9006d408418f453e90194db4dc005e279612814760e837d6ee0940936dd75"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b41d654f07a5bc5ee9f20f01e25835f0f76caaf8c58662695c404fd6565d86d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0aea37bffd3d25471c46dfdf81c30023e751b88500db7e7019b9a154eae9162"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2342caa95e630623f295c71dfe030360f852818a071b06af812ac9bd96561b63"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6471c476cfb8d5888a71f888d2bc6646d8d3816b7d4c31579b04847806c6961"
    sha256 cellar: :any,                 arm64_linux:   "196d2d0a8cf3eb4b5f4f467542fad2390f3a51acec168fdef432e15b11f9e0fd"
    sha256 cellar: :any,                 x86_64_linux:  "a0ef62c5a0a1419a6b1fa7dabdfc560c120c63c93e6f3d6c563b9549bf771a05"
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
    dezoom_out = shell_output("#{bin}/dezoomify-rs tiles.yaml testtile.png 2>&1")
    assert_match "Image successfully saved", dezoom_out
    image_dimensions = shell_output("identify -format \"%w×%h\\n\" testtile.png").strip
    assert_equal "512×512", image_dimensions
  end
end
