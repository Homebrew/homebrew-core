class Dnglab < Formula
  desc "Camera RAW to DNG file format converter"
  homepage "https://github.com/dnglab/dnglab"
  url "https://github.com/dnglab/dnglab/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "432b8ac8f553289e06c0d78b37ae6f9546e80b736ef879f2ee66b66345590c4d"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7c17db110faa5bbd3b4969611566769f0576aef59934c3afbdbe63acea63e672"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "27d958d8246856fb1a25e3dd521762bcbf1b87822f790f4a6cc238b23a3ab8dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8ce158b689cc93fb85322d9e0df0afa2f224e0588ffa510856bdbe4d830000b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "13168fe0f37d3d963270e65af52567427f0db526df6c42b95929eea9b2eb01fa"
    sha256 cellar: :any,                 arm64_linux:       "670fb5a9c5299075b1c181006e827fb6208c2a5eb7ab24c98e2e4dc73caa7e1a"
    sha256 cellar: :any,                 x86_64_linux:      "2b0ff147fffa91adf12ba1b1e7ba9ac65c203a27837db384380546ee9ee83563"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "bin/dnglab")

    bash_completion.install "bin/dnglab/completions/dnglab.bash"
    fish_completion.install "bin/dnglab/completions/dnglab.fish"
    zsh_completion.install "bin/dnglab/completions/_dnglab"

    man1.install Dir["bin/dnglab/manpages/*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dnglab --version")

    touch testpath/"not_a_dng.dng"
    output = shell_output("#{bin}/dnglab analyze --raw-checksum not_a_dng.dng 2>&1", 7)
    assert_match "Error: No decoder found, model '', make: '', mode: ''", output
  end
end
