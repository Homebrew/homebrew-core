class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  url "https://github.com/MaskRay/ccls/archive/0.20220729.tar.gz"
  sha256 "af19be36597c2a38b526ce7138c72a64c7fb63827830c4cff92256151fc7a6f4"
  license "Apache-2.0"
  head "https://github.com/MaskRay/ccls.git", branch: "master"

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256                               arm64_monterey: "b8c13816cd75809e6ea41113e55f37c547aeba195c648c47af3863921ac85115"
    sha256                               arm64_big_sur:  "11204e506ee765088067057072547cb7b190fb466ff719d8a1de0fd0b4116a7f"
    sha256                               monterey:       "a6eecb14e3e58561d8e4d76049624d31df4ea00921ba77116d0dc5e100caf5a9"
    sha256                               big_sur:        "c48483f72436fd6e4b1a8c3928b436bd48047e396540ce47de06914554b5b064"
    sha256                               catalina:       "338d1b8848c2a3b380e65551a1a5f38da4c9eb8d8f6968fdef694daf529023e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1da50c69833e7af97b6ebf40b1b6a1d45ba1577b3a80baede95990ed8270488"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm"
  depends_on macos: :high_sierra # C++ 17 is required

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
