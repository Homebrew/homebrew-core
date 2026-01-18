class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.22.tar.gz"
  sha256 "4600c344ae29b290d9bd3cccd9ee5611352be1bbda1e1a0e687ac58c0dc546c5"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e9130cd4b5d5c676b657b1448184abdc26975ed3350abce063aef1790090626"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa677924fb2dff41cfefda046ba45ec7452b969bf9c372a2bd66d42954d87f65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a521baff4b9361e4f742f33c91aeec7b605ff913a91d0fc6c53383f6b44bc15e"
    sha256 cellar: :any_skip_relocation, sonoma:        "48cbb1456cbe0706b8bfd10ccc481016cdb482f884679b56f79a7ef60f2210c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91aee59849b1e680f5cba0ea18baf4afe2c2235d7f879b91959ac12844fe67c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a9adf7f9c8776c77a17927be76b216d4109e21c5aed87f64f87aaac067ffa1a"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix

    generate_completions_from_executable(bin/"gauge", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"manifest.json").write <<~JSON
      {
        "Plugins": [
          "html-report"
        ]
      }
    JSON

    system(bin/"gauge", "install")
    assert_path_exists testpath/".gauge/plugins"

    system(bin/"gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end
