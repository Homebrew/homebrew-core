class Macpine < Formula
  desc "Lightweight Linux VMs on MacOS"
  homepage "https://beringresearch.github.io/macpine/"
  url "https://github.com/beringresearch/macpine/archive/refs/tags/v0.7.tar.gz"
  sha256 "47777dee26c6c9c0d0683e9e6b0d8dd85b20c1336cbeffaa9f1be0b6fcedf8d7"
  license "Apache-2.0"
  head "https://github.com/beringresearch/macpine.git", branch: "main"

  depends_on "go" => :build

  conflicts_with "alpine", because: "both install `alpine` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "NAME OS STATUS SSH PORTS ARCH PID", shell_output("#{bin}/alpine list")
  end
end
