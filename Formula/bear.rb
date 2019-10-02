class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.4.2.tar.gz"
  sha256 "e80c0d622a8192a1ec0c0efa139e5767c6c4b1defe1c75fc99cf680c6d1816c0"
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
    args = std_cmake_args + %W[
      -DPYTHON_EXECUTABLE=#{Formula["python"].opt_bin}/python3
    ]
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "#{bin}/bear", "true"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end
