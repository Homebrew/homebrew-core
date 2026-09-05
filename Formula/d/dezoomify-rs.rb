class DezoomifyRs < Formula
  desc "Tiled image downloader"
  homepage "https://dezoomify-rs.ophir.dev"
  url "https://github.com/lovasoa/dezoomify-rs/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "c88920aa1d90eb546b53af8f1c0a497491fa4664d87dd1ee496b217af8923675"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4278295b02ab9bb9238647062c80d212d5ac7dca1ef11c6b58a202e2d13f272e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d56ffe89a721d957109b8584323b5776a3cc09d69bc66ee6ff3cca84e43f64a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c98b45e9728f62fa83f361e2d45ab574585ef4143c2da5a47698b573e9f1228"
    sha256 cellar: :any,                 arm64_linux:   "72782237b0bdfa2759b02f8e7367d54b2f9c0f5f22b3bfb5e03e9f8f412859f1"
    sha256 cellar: :any,                 x86_64_linux:  "7c5e8aab13824ebf5de540e3e09b11355eee779f28c9454171cf6e828766ccdd"
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
