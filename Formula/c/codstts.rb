class Codstts < Formula
  desc "Code statistics tool analyzing programming language distribution"
  homepage "https://github.com/zheng0116/codstts"
  url "https://github.com/zheng0116/codstts/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "31e6b46b8f43a52a4b036d07b50ea7faa11f562c01582ecda6d861679ca3f3d8"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/codstts", "--version"
  end
end
