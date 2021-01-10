class Hnterm < Formula
  desc "Hacker News in the terminal"
  homepage "https://hnterm.ggerganov.com"
  url "https://github.com/ggerganov/hnterm.git",
    tag:      "v0.4",
    revision: "1991148eba3aa0d6c35e33210e6b7a9043cb495c"

  license "MIT"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", ".", "--target", "install"
  end

  test do
    system "true"
  end
end
