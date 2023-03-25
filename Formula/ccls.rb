class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  # NOTE: Upstream often does not mark the latest release on GitHub, so
  #       this can be updated with the new tag.
  #       https://github.com/Homebrew/homebrew-core/pull/106939
  #       MaskRay/ccls#786
  #       MaskRay/ccls#895
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/MaskRay/ccls/archive/0.20220729.tar.gz"
  sha256 "af19be36597c2a38b526ce7138c72a64c7fb63827830c4cff92256151fc7a6f4"
  license "Apache-2.0"
  revision 9
  head "https://github.com/MaskRay/ccls.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "3bf73031c131831f360e1fcd68d7267bb080c53b62723a719b07f4348d87ab32"
    sha256                               arm64_monterey: "fffce7f507ca1db7c1b1dd7914c969f9430b10b84b6db722f9e078e85a17db3c"
    sha256                               arm64_big_sur:  "1ba6239e608393fb450165fc30f559f72f5e4061560eb46e5551e5fcd0db877a"
    sha256                               ventura:        "dd6f5f4226c8698be3bee089399f77ba83ce3e187d7425b5b157a8dbcbfb9d36"
    sha256                               monterey:       "8d4602d4946b959f8d35583b82bae88b1f7ee150f2ca026cd20ab360c2a1a452"
    sha256                               big_sur:        "d6410e69b34badd6a25203edce2d3d20c28d1ddf0d4080542ffc7d592ca5dc05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7b2be6becc5ce199cfc6ea6a1d8eadab24addb7ace49634c2e941d8eaf1d3ed"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm@15"
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
