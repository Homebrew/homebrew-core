class Mmtui < Formula
  desc "Terminal user interface for NCAA March Madness brackets"
  homepage "https://github.com/holynakamoto/mmtui"
  url "https://github.com/holynakamoto/mmtui/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "cb2966ae8ad79d28d390ae0fc9ed9dc45bc0aa34889d783cd3b099e2a76bf6ae"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mmtui --version")
  end
end
