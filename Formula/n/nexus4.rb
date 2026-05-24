class Nexus4 < Formula
  desc "C++ based interpreter for the Nexus language"
  homepage "https://tiwut.org/nexus"
  url "https://github.com/Nexus-Titan/Nexus-the-programming-language/archive/refs/tags/V4.1.1.tar.gz"
  sha256 "f8be7ddcc12865fdfea4bc88e42b000b7ae2ed9cf69523be92741932a8b319be"
  license "MIT"

  def install
    system ENV.cxx, "-o", "nexus", "interpreter.cpp"
    bin.install "nexus" => "nexus4"
  end

  test do
    assert_path_exists bin/"nexus4"
  end
end
