class GoAir < Formula
  desc "Live reload for Go apps"
  homepage "https://github.com/air-verse/air"
  url "https://github.com/air-verse/air/archive/refs/tags/v1.64.5.tar.gz"
  sha256 "344202da98e4497825feb7459a6728ea113fffcf661215cf1ee4f313f3324a86"
  license "GPL-3.0-or-later"
  head "https://github.com/air-verse/air.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12f3bc2d4b5e5fdcbd76612520f2906ee79c4fb0f768ce29eb0d3147d8cd92c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12f3bc2d4b5e5fdcbd76612520f2906ee79c4fb0f768ce29eb0d3147d8cd92c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12f3bc2d4b5e5fdcbd76612520f2906ee79c4fb0f768ce29eb0d3147d8cd92c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b28c28519a3700172e21c7f4d30990c30433a39a28bf2759b22f79197229fe9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "970f3b4df1c5a7bcd28eeab5f1e3f6f0ab1f412ebba43f253a082b0ec9ef9627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42c93ec8eeda78f5fa45f843478cbf42feaa3764656888dfccee773348e4a2c2"
  end

  depends_on "go"

  conflicts_with "air", because: "both install binaries with the same name"

  def install
    ldflags = [
      "-s", "-w",
      "-X", "'main.BuildTimestamp=#{time.iso8601}'",
      "-X", "'main.airVersion=v#{version}'",
      "-X", "'main.goVersion=#{Formula["go"].version}'"
    ]

    system "go", "build", *std_go_args(ldflags: ldflags.join(" "), output: bin/"air")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/air -v")
    (testpath/"air-test").mkpath
    cd testpath/"air-test" do
      system "go", "mod", "init", "air-test"
      system bin/"air", "init"
    end
    assert_path_exists testpath/"air-test/.air.toml"
  end
end
