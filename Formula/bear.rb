class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.4.3.tar.gz"
  sha256 "74057678642080d193a9f65a804612e1d5b87da5a1f82ee487bbc44eb34993f2"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "e25773345f9d8aa3c59c6960f0773de9fb2abd9681f0556a7f4618aaaaf71363" => :catalina
    sha256 "3b418502dd23b131e1e9dfbe7dc3ea2c4f93fcc538f8dd3e286fcccae55d7f6d" => :mojave
    sha256 "d7be3483e460d6b959060270c6de75d1fcc46cfcd0a02969dd94102679848e4a" => :high_sierra
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
