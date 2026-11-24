class DezoomifyCli < Formula
  desc "Download zoomable images from museum websites, image galleries, and map viewers"
  homepage "https://dezoomify.ophir.dev"
  url "https://github.com/dezoomify/dezoomify/archive/refs/tags/26.11.24.tar.gz"
  sha256 "719bb3b2fc9d78f9e4e27cdafb59ae055e981bb2af14f9d6d6895b1a4d7bcadf"
  license "GPL-3.0-or-later"
  head "https://github.com/dezoomify/dezoomify.git", branch: "main"

  bottle do
    manifest_sha256 "6220dfe318d08070f56208185aa8b4ed121f850e2188877ccea421a778e8e671"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fc3a24828307953017e543a22c4909765acc4c4b19857820d253909566fb31f7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fa8f820fc0c3215015a94fac0f78c105c75be5341e3035e25a84c8c094f372aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "147869406a9e8d312628615377c83a66e6e1da6def06e4870b810c563066fb63"
    sha256 cellar: :any,                 arm64_linux:       "82fa843c642c90f5cc70197cab8ce5b4433e1eeddc0d59c3b0a883886d5d1083"
    sha256 cellar: :any,                 x86_64_linux:      "b22368cc7c82f9582bbc98af1f08b6f6af3ebfe4bd2be1a3f4fae70a82f92740"
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
