class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  url "https://github.com/MaskRay/ccls/archive/0.20220729.tar.gz"
  sha256 "af19be36597c2a38b526ce7138c72a64c7fb63827830c4cff92256151fc7a6f4"
  license "Apache-2.0"
  head "https://github.com/MaskRay/ccls.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "7a700c856f8fddcb51898902e141a7bf2b00cf1d534ad44e368761eaea80c6a9"
    sha256                               arm64_big_sur:  "f8de1cf356810a3b604fd13f526608cf4ad4ab4c4e70b8474693b580552b0f8f"
    sha256                               monterey:       "5a6b516516d46abbf4668b5e9eec5e88840c5a2ca73432696d8ab2d9a641a074"
    sha256                               big_sur:        "b68c5cbc9bdfcb100fd62c6b358a3686735d0e3557ce0a1237499dcb8080bf64"
    sha256                               catalina:       "831dfbfb728bffc850add851055b9d6eedf5adb74250a08eed8e05997d760695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1dbb3ade81ce1ad9d4f63cde3620d72513097d2835b1e74d80e3a9d1999d66e"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm"
  depends_on macos: :high_sierra # C++ 17 is required

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def llvm
    deps.reject { |d| d.build? || d.test? }
        .map(&:to_formula)
        .find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    resource_dir = Utils.safe_popen_read(llvm.opt_bin/"clang", "-print-resource-dir").chomp
    resource_dir.gsub! llvm.prefix.realpath, llvm.opt_prefix
    system "cmake", "-S", ".", "-B", "build", "-DCLANG_RESOURCE_DIR=#{resource_dir}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/ccls -index=#{testpath} 2>&1")

    resource_dir = output.match(/resource-dir=(\S+)/)[1]
    assert_path_exists "#{resource_dir}/include"
  end
end
