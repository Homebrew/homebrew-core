class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.4.1.tar.gz"
  sha256 "41e118471f11d91147490561b3bc52228a9ffc2a293e8e03717d674a0e312a9c"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "b540bfb4df22cda3cec0e2c1b3eb688ac34d67ed4b051063f05d44ff0c1da351" => :mojave
    sha256 "19ffa59864de423dc7ae53767bb934f0355a77f3e5643cee73e5d4b84c073d8c" => :high_sierra
    sha256 "0adda8dd7614d65451b1ea7fe36e3fd378672fc9ff828fbeb6ec0fb182d8ede7" => :sierra
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
