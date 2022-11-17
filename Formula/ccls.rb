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
  revision 6
  head "https://github.com/MaskRay/ccls.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "f4170fd9502d4163f1e81b1e586844d092bb2d244bcc489515e1c21b562dd181"
    sha256                               arm64_monterey: "fe85213a57a49cb8fdd9b2dd1064a27a3a15480c4e2760b6f0822a28d0e0e5b8"
    sha256                               arm64_big_sur:  "a478d9d56f092d5c0af5cc2eba95ce92b8aa4e4c715a588f51ef221b917f30a3"
    sha256                               monterey:       "7e1ba5791ef7efd463cec861d325a317a1876772fff1d7e76b5ad96ff9296df4"
    sha256                               big_sur:        "b4bf1dbeb732b55126523f4f207d87702f0ccb4e916804b4addc5438c81b81fc"
    sha256                               catalina:       "f6c5a5e8968fdf4001ba476fe88203c8aa0b2f8befa3e97704a2d34f810a3007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c581f6afa20b0ba3c29d2603253492aadb6f9172a374442ceb2f8f48c6b948a"
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
