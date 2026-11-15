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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "179f2ed66371b6ff9cb9ce85d486da8fea363df71a27d579d423f2bec5923667"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "12d4c54639a279ddecce1ee261cf5332a6ab5502c05732d18e8de29d28ca7be6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b5440984a1efd75c6d8055918470d46ebc4974c6263ca661fd1ccf7fab66662d"
    sha256 cellar: :any,                 arm64_linux:       "af7f8fa647d4f69dda36180b8f61c55f87127b8f32549c711a4d22a09781f5ed"
    sha256 cellar: :any,                 x86_64_linux:      "a8944cd48ae08c98eed6b573046448fca162138eb57178726ba6755b844d19c3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "imagemagick" => :test

  on_linux do
    depends_on "openssl@4"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
