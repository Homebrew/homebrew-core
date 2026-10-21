class Dskditto < Formula
  desc "Ultra-fast duplicate file finder TUI/GUI"
  homepage "https://github.com/jdefrancesco/dskDitto"
  url "https://github.com/jdefrancesco/dskDitto/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "bb017dea15bcd2a4b5877b33945b299afbfec903e07e75f8f3f0ec43112a0efa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dc3b03b384127ac8ea76b3c4cb94818c0e723b1723c3d73d3adc51ce36d5c53e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ec7db1d2e4da9ed21f7ddf628adbb460fac9e6bd2f69688e1d30bbfc48217233"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "891c1d95587e1f64db1457a9248bb39676cd76fd7b86b25593b764c92c1f7797"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9065b44504b537f8c85d979b19cef8788a3a8bd2ff08a487435a545420d7a14b"
    sha256 cellar: :any,                 x86_64_linux:      "d0623d67f84ec0e3fa537a2a3c405902625436e5793b1060559d9d18a5f1410d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
