class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/5.6.6.tar.gz"
  sha256 "95fac3df4311d4fb6e2674b1bce3113056795a2eda51cd807f73bcc4f9b1a2d5"

  bottle do
    sha256 "60f78cb2d1d98252b692148088adc943a0a352cf406cb27d17b2e91ce806e6b7" => :mojave
    sha256 "e2f0c70e9fe5d4ca97dffc565fd9bab7f981b50854d30ff98d148725c46c21d6" => :high_sierra
    sha256 "7606b0132df130bf0eb3b74989e829361074144ef2c8b49dddeb86e414a5869d" => :sierra
  end

  depends_on "cmake" => :build
  depends_on :arch => :x86_64
  depends_on "boost"
  depends_on "python"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DNOM4RI=ON"
      system "make", "install"
    end
  end

  test do
    (testpath/"simple.cnf").write <<~EOS
      p cnf 3 4
      1 0
      -2 0
      -3 0
      -1 2 3 0
    EOS
    result = shell_output("#{bin}/cryptominisat5 simple.cnf", 20)
    assert_match /s UNSATISFIABLE/, result
  end
end
