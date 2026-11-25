class DezoomifyCli < Formula
  desc "Download zoomable images from museum websites, image galleries, and map viewers"
  homepage "https://dezoomify.ophir.dev"
  url "https://github.com/dezoomify/dezoomify/archive/refs/tags/26.11.25.tar.gz"
  sha256 "556b0c421b7a2a53186eded521fe55961e5dfe5e5f705b818a70dd73057d0360"
  license "GPL-3.0-or-later"
  head "https://github.com/dezoomify/dezoomify.git", branch: "main"

  bottle do
    manifest_sha256 "a06b8ea8a1fe766dd6eb6a487d609c52738e53329ae388df461a66b409c16110"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d755b7bd507dbd37d856c1deb7c4016a49885eb50d55303aa46f9cdc34c5aafa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fafbacea440a870099348124b954571bdc27a15a530472a498c8d2e812157ba9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9ba5a9b02c749069b5aae667985c2a058914d894397b15381d10a22313da1be6"
    sha256 cellar: :any,                 arm64_linux:       "1f8e0b68ddba224dc85305fbace7fde428e7bdc68a7de18d00300acd9e1377d7"
    sha256 cellar: :any,                 x86_64_linux:      "3c250fd78f9c4432ce1f9369da6baaea67bed405d0cb071d3af67a32caafd430"
  end

  depends_on "node" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  allow_network_access! :test

  def fetch
    system "pnpm", "install", "--frozen-lockfile", "--ignore-scripts"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/cli")
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
    dezoom_out = shell_output("#{bin}/dezoomify-cli tiles.yaml testtile.png 2>&1")
    assert_match "saved testtile.png", dezoom_out
    png = (testpath/"testtile.png").binread(24)
    assert_equal "\x89PNG\r\n\x1A\n\0\0\0\rIHDR".b, png[0, 16]
    assert_equal [512, 512], png[16, 8].unpack("NN")
  end
end
