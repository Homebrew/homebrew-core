class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  # NOTE: Upstream often does not mark the latest release on GitHub, so
  #       this can be updated with the new tag.
  #       https://github.com/Homebrew/homebrew-core/pull/106939
  #       https://github.com/MaskRay/ccls/issues/786
  #       https://github.com/MaskRay/ccls/issues/895
  url "https://github.com/MaskRay/ccls/archive/0.20220729.tar.gz"
  sha256 "af19be36597c2a38b526ce7138c72a64c7fb63827830c4cff92256151fc7a6f4"
  license "Apache-2.0"
  revision 8
  head "https://github.com/MaskRay/ccls.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "fcace1d89ba9d7c67ba7073240f00f61cb30c604d62b4485a3501486284a578e"
    sha256                               arm64_monterey: "371ef78d4aea810ed344f34790603bb88b01fee575eab7ff7969878d81095b9c"
    sha256                               arm64_big_sur:  "101591ed613a17a252452e78b69786b332de710023923e544cd9b5b0ad63e147"
    sha256                               ventura:        "9eac337ffa1a43ce712acb0d987856120f9a68cbaffbe25da993ad62940102b2"
    sha256                               monterey:       "4536d5b4554fad0e7c9a1ae913b0bd783403ef34a3ffed1e1405cb57657e82e7"
    sha256                               big_sur:        "40357fd7029cc87fa6a7a8945bb13e922e7c0c53a3373fbd50ba1a958fb58176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da6c69295bbe7bb0e8a896414f48981b00e118af2f222c9053b8c14e211825cf"
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
