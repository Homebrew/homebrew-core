class DezoomifyCli < Formula
  desc "Download zoomable images from museum websites, image galleries, and map viewers"
  homepage "https://dezoomify.ophir.dev"
  url "https://github.com/dezoomify/dezoomify/archive/refs/tags/26.11.19.tar.gz"
  sha256 "ca822190ad74f3d5d8110f6135bced40053a94e74d3524b676276faeb9f87699"
  license "GPL-3.0-or-later"
  head "https://github.com/dezoomify/dezoomify.git", branch: "main"

  bottle do
    manifest_sha256 "aa038a4402ccc5fa6d93c79871bbeb67686262fa80c3d2c13750cf5ea9f547ad"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "47c213a9040e68dc25a8e1584c05416791826348014523379d8dd061cdd9a771"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "691ec215357bc33ac33ae6592155793771cbd9c251848adc68c5b2b8cee438ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ac0103adf78429b95ef9fa1d197c82e4ede1b7bd7d2cc6c9d96ffb667ddbb7aa"
    sha256 cellar: :any,                 arm64_linux:       "41f0893331069fbdaf7964669f65f86447c46184af7377e7475b9c3bbf97293c"
    sha256 cellar: :any,                 x86_64_linux:      "c89869e914fd627787606d034ac8ed8ba898b6c497189b0f5bd2519f72d12206"
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
