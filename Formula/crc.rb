class Crc < Formula
  desc "OpenShift 4 cluster on your local machine"
  homepage "https://code-ready.github.io/crc/"
  url "https://github.com/code-ready/crc.git",
      :tag      => "1.10.0",
      :revision => "9025021f545acab4c3e3016bed0172490ce53c72"
  head "https://github.com/code-ready/crc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d5ea105fcf3eb8eaa51b7406315e75cabae5818a8b1e6ff10c5ad60d3a19e3a" => :catalina
    sha256 "debc9c3add86f3310e791cbf8845e865aa6873ae8c34db4bd3a07363ba6e2655" => :mojave
    sha256 "6197d7e12e8bcbed963a73f921feb3ff685be93bde7ce82e3a3ee9b0ac590ce4" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "out/macos-amd64/crc"
    bin.install "out/macos-amd64/crc"
  end

  test do
    assert_match /^crc version: #{version}/, shell_output("#{bin}/crc version")

    # Should error out as running crc requires root
    status_output = shell_output("#{bin}/crc setup 2>&1", 1)
    assert_match "Unable to set ownership", status_output
  end
end
