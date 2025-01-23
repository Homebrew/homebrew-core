class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https://github.com/curlpipe/ox"
  url "https://github.com/curlpipe/ox/archive/refs/tags/0.7.6.tar.gz"
  sha256 "03f49425e889e9ee4b747de219261c5aaebbaac11a0aa7266dca4e4c2581f6c4"
  license "GPL-2.0-only"
  head "https://github.com/curlpipe/ox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bea80c32a63ff251a6428a170ba6402091834ad6846635f288c4efeb601ce3a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "034649040ad9a329b16ab5a3a0c18113c20cab47d63f00a94e75713c11a54510"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2d48a5bc43d34ac30f84eb0e507eb5d3fb73d393286af5662948b2afc36c3be"
    sha256 cellar: :any_skip_relocation, sonoma:        "41532edb00ef96ba6346011a1057202ef9a3602d42d3da04839a338345b3fead"
    sha256 cellar: :any_skip_relocation, ventura:       "9c327b3d448432735deb00647d1f72812d9b35929fcbce0036dbd1f6e7196a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f2985d8efc0d2747ac8fe29726da94dbeec78547b0302d13690300413ee9d2e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # ox is a TUI application, hard to test in CI
    # see https://github.com/curlpipe/ox/issues/178 for discussions
    assert_match version.to_s, shell_output("#{bin}/ox --version")
  end
end
