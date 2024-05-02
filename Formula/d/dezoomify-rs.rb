class DezoomifyRs < Formula
  desc "Tiled image downloader"
  homepage "https://github.com/lovasoa/dezoomify-rs"
  url "https://github.com/lovasoa/dezoomify-rs/archive/refs/tags/v2.12.3.tar.gz"
  sha256 "9887bb1004eb7131635e301a26dce24e58ffb2509d6d86199c597cc2610ef38a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef184fa83a2ac122022638a77914f1bc2ea23ddfb728785758d257e0574142b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57934996de762d6b3816295ef4fdc1ebbd37c71558baedf03b1cdc3c6197a1c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19ecdf6aa76f213cfbaaf068fc67e35cf6e1ba7f7c3321730de5bb6c6a163a2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce69409b31e7ffcd0a1622f3515997b70099f7a21ffc9a58d72325054291306d"
    sha256 cellar: :any_skip_relocation, ventura:        "ba79b6bf7e8f85d21e225c1ba20019e18cf214e6479b007d13f7b08ccf5d78e8"
    sha256 cellar: :any_skip_relocation, monterey:       "60ecfc32ac38a3fb90c9d768b9cd1f75d5e0ea915f7bccfc3ca44ff73df84ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c47572cd704554dfb6caa6bcb7f9c5b7ea888f548aa3f9163be82f6b68285242"
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
