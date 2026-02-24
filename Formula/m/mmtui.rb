class Mmtui < Formula
  desc "Terminal user interface for NCAA March Madness brackets"
  homepage "https://github.com/holynakamoto/mmtui"
  url "https://github.com/holynakamoto/mmtui/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "9a67c83133f86d036cc7e98c0f961aa3a490bc8cc72ae8964087a3259adcd9d7"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mmtui --version")
  end
end
