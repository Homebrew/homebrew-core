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
  revision 4
  head "https://github.com/MaskRay/ccls.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "9b738c093c8e77d40b9a03996c88ece24effccbd6d753c16f41943391ec25f7c"
    sha256                               arm64_big_sur:  "3e8b71cd7d9ad577126b6e0596161d66789c903cdd3defd85bf26a32a6e662a4"
    sha256                               monterey:       "3fd5c9891ad57191ef49db4f54950a02270a4c873b87dbbb1d93827837ee309f"
    sha256                               big_sur:        "8715101674b0f316b11fdc3b4068ecee8e342de3c535f101ca9a116844f87dcf"
    sha256                               catalina:       "cd500eb00d975227f3670015514ab8ea763b8f97db4522730ad865e7c5def1c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfb3b2faa8bc5058eae34711d411646c62ef0b737cbac7db3b4a2e3c9e0b95a8"
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
