class Bomber < Formula
  desc "Scans Software Bill of Materials for security vulnerabilities"
  homepage "https://github.com/devops-kung-fu/bomber"
  url "https://github.com/devops-kung-fu/bomber/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "05c505678172dbf1f14473be2a17dc531b4db05dc70c74ed98f12f7ab0db3a8f"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2d9ee19477631f20213b148d7949b4cc579ed166ff85c4bb25b0b98c4ac0a0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6476378d4fdf202c5dacf811ea22b43d73ac1a2ab334e0356c71dd431fb0d8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "496ad89cd3de482d2c0595a43cc0407f122c41658faf22a87dfeb7c493e2a3cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "c24d982ea826137d3c860f4f48a17f2d45405513d0f6604b6ee3f686d55fe1a8"
    sha256 cellar: :any_skip_relocation, ventura:        "ce0bcd10fa126b773f14c0dab28e2d1fda20801002bb09c4c11b8250eef04559"
    sha256 cellar: :any_skip_relocation, monterey:       "5e852c782540052df6a605a1d3f3dc06c03fbbe6b53ee02d980a6d08671d102f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16c0deffdaa4a0ffa0e7d5014c6aa625cad9d8183b8ac9fee4b3d061ccd61bab"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"bomber", "completion")

    pkgshare.install "_TESTDATA_"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bomber --version")

    cp pkgshare/"_TESTDATA_/sbom/bomber.spdx.json", testpath
    output = shell_output("#{bin}/bomber scan bomber.spdx.json")
    assert_match "Total vulnerabilities found:", output
  end
end
