class Dskditto < Formula
  desc "Ultra-fast duplicate file finder TUI/GUI"
  homepage "https://github.com/jdefrancesco/dskDitto"
  url "https://github.com/jdefrancesco/dskDitto/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "5202c2f0482b0496e272ced4ccd820ff47bbac73ed2237acad501091a79ec259"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e9c483de09e5f0896dbdca6df1a9ca32f2d47e2b89aaed1247733216a3cec523"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1ca4a2304114d2f4332d329adab2ec5fec8f9f0ab9b191b01cd4d52a784b932b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a16e68e55ffca5b18232cc30709c44f4d3ca2f4f5142e9b0c5c4ca835a8c4e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "af033c1d6ad53bb4e469746c09e1d7820453f920149eccd7281be8ddf6e92661"
    sha256 cellar: :any,                 x86_64_linux:      "7c7f22d12b8fb9e04ca86a2cd9294cb331d94d722f1fb362379674d1a831891d"
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
