class Clavus < Formula
  desc "Clavum Lateris"
  homepage "https://github.com/peter-mbx/clavus"

  url "https://github.com/peter-mbx/clavus.git",
      tag:      "0.0.1",
      revision: "3d7e77f3cab1118b7e30c88a3ebb55e9c966a26e"

  license "MIT"
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    system "cargo", "test"
  end
end
