# Imgurbash2 formula
class Imgurbash2 < Formula
  desc "Shell script that uploads/deletes images to/from IMGUR"
  homepage "https://github.com/ram-on/imgurbash2"
  url "https://github.com/ram-on/imgurbash2/archive/refs/tags/3.2.tar.gz"
  sha256 "a17ef6c96399550293ee806bae4665e4353c3280df4d3ebe041cf589fe6bc259"
  license "MIT"
  head "https://github.com/ram-on/imgurbash2.git", branch: "master"

  depends_on "bash"
  uses_from_macos "curl"

  def install
    bin.install "imgurbash2"
  end

  test do
    system "#{bin}/imgurbash2", "--version"
  end
end
