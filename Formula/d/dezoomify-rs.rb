class DezoomifyRs < Formula
  desc "Tiled image downloader"
  homepage "https://github.com/lovasoa/dezoomify-rs"
  url "https://github.com/lovasoa/dezoomify-rs/archive/refs/tags/v2.11.2.tar.gz"
  sha256 "19bcd079d8a370456080ba65b2f51fa4aa2eee00207a18aa9782dd7faef9acb9"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8ee8cbf3a5d1131cbfed81cba85e5e9ba08d3dd4dc55cd1f19fa10baf4348b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e6a9fc41bbb3c0097249716df70783dc0fa81fcb5b5205a36a94bd46a66cebd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a30fecc2477cbaf77e58fdee531da5f9654924fa640fb89b501122afb503fa12"
    sha256 cellar: :any_skip_relocation, sonoma:         "c52169589437e1d5dd043330a954b3b68d0d5ce0bc012bb53eeb53ad8b89e978"
    sha256 cellar: :any_skip_relocation, ventura:        "fab012b5a9cee64cbcb8964c3e0e84f542b94cf4ca26333f838b1eaedf3e56e1"
    sha256 cellar: :any_skip_relocation, monterey:       "69f85c169aabda49f35e7ffc0666ceeddb96df31105bd3e216ae7708900979c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ac410c0b20e59d8434e9e3a2143f5c81b20bcb5b80296120e01659e40f6d5c3"
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
