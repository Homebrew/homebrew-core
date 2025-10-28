class Pathspy < Formula
  desc "Debug command resolution, PATH conflicts, and binary issues"
  homepage "https://github.com/adityavijay21/pathspy"
  url "https://github.com/adityavijay21/pathspy/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "43085afbb0617dcfeeadde132e1af5e77839ea5d6ee7fe10f02fa4084b3120d1"
  license "MIT"
  head "https://github.com/adityavijay21/pathspy.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "pathspy", shell_output("#{bin}/pathspy --version 2>&1")
  end
end
