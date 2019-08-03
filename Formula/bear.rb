class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.4.1.tar.gz"
  sha256 "41e118471f11d91147490561b3bc52228a9ffc2a293e8e03717d674a0e312a9c"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "e8bca8513bbc0f7a9d3e53554bec2c948c580b92f9c58eddd1c5be6d456ddcc0" => :mojave
    sha256 "cfe8de393c85c1e25e3d2db22be0f0dcde2a51baf2c3b6d5f6e6f9e04ba27da9" => :high_sierra
    sha256 "0969703024e07bc236911a16ccf17485f65177e858fbd9bd97fd29729fc7957b" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "python"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/bear", "true"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end
