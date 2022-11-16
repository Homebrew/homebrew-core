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
    sha256                               arm64_ventura:  "f7178cef61892a7ca59a999a2b80879a9b35d61fa347095f357034f6ac0e108f"
    sha256                               arm64_monterey: "06a36dcf5ff00a0f2046dd4aaae959dd25942ff9be40724a3e60a14323095f14"
    sha256                               arm64_big_sur:  "12c05e346f35036af3b4578a2c0da7da5fcb52a6b10aff960a96a61de14a1625"
    sha256                               monterey:       "09d0f9d632231477f9e47b36b8d82be4aee3eca78c2ff8bb7c26c4ef402fdb8d"
    sha256                               big_sur:        "0bed7797a38eec212e12a4635282fa44faca14cf07883913a80b06f112663970"
    sha256                               catalina:       "b7de9d833bb9fe53910bc56f6af1df40084b6b259a45ac961fc645ce305c722d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "170a80f752bed26931497a307cd142e9e75ee9478d39ecc1822175b71c362733"
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
