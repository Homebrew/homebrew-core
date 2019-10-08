class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.4.2.tar.gz"
  sha256 "e80c0d622a8192a1ec0c0efa139e5767c6c4b1defe1c75fc99cf680c6d1816c0"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "95726dc7ffc8bd4df3f976d0c3cdbbadf1509c755de876d855cbb21e625fe6cb" => :catalina
    sha256 "fd0d8a9cb6c5182d128bce82ed98c72c5960a12c927d30100f8fbb9834af6ef4" => :mojave
    sha256 "55dd8a9e37ef3f78dfa13f963cf1c7f82db6c026f449cce1dd1da47123b2a49e" => :high_sierra
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
