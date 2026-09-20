class Dskditto < Formula
  desc "Ultra-fast duplicate file finder TUI/GUI"
  homepage "https://github.com/jdefrancesco/dskDitto"
  url "https://github.com/jdefrancesco/dskDitto/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "5202c2f0482b0496e272ced4ccd820ff47bbac73ed2237acad501091a79ec259"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ff6eab951dd69d4e1b307cfe3e297887d06c0b010b8bc9e78448c5c333f7d2c5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "22cbf423e9869ba00882876194eff8a48672b32af7e0fd8be6abd2a3dcaec829"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5218ab5ad5ec6b2d31b3650a8e4c5a703db5c907f044265b45ea93da37abe6fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3d9b70b32f608a6cf17f07e3b6fc6f4a13008cc5b9713206d0c30aaf81de9935"
    sha256 cellar: :any,                 x86_64_linux:      "78de8f29ae8e4801e62b14b8066a8e09a9777ceddbe8f9ed2459487ae37f9465"
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
