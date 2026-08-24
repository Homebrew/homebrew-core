class Dskditto < Formula
  desc "Ultra-fast duplicate file finder TUI/GUI"
  homepage "https://github.com/jdefrancesco/dskDitto"
  url "https://github.com/jdefrancesco/dskDitto/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "22eb67b680df785709d3cdb0343f7db1e9c99c51788fa518ab0da52d1475e737"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77aed6edb4dd72dbd72789c70f133ad1ced9434d14d14113de5aae5744b28609"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72a2e13c6d44e7da7fba371a10317c47409bf22a6d1067ebd1f1d38e2a7797eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6794c196365af15e59e612b836e971016347aeba90aa3948c997004519f166d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ccf4d828605f0eb27f330d9759256641d5eb3db06689ed270c573ea3b93e71e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c2bc6da92134992cf7772f612d8d4088d5aafc0aacd45f2a9c63b899fc23e9a"
    sha256 cellar: :any,                 x86_64_linux:  "be75aea33d6dfd2e62f326cec7fc75bdd0f3b67d09234ad71e92cde90cc50f15"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/jdefrancesco/dskDitto/internal/buildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dskDitto"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dskditto --version")
    assert_match "GUI support was not built", shell_output("#{bin}/dskditto --gui #{testpath} 2>&1", 1)

    (testpath/"a.txt").write "This is a test"
    (testpath/"b.txt").write "This is another test"
    cp testpath/"a.txt", testpath/"c.txt"
    output = shell_output("#{bin}/dskditto --remove 1 #{testpath}")
    assert_match "Removed 1 duplicate", output
    assert_equal 1, [testpath/"a.txt", testpath/"c.txt"].count(&:exist?)
    assert_path_exists testpath/"b.txt"
  end
end
