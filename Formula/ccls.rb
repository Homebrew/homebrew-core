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
    sha256                               arm64_ventura:  "d87fa33e73775b581e9a146b7cf9e658d39c84793aad7d7ce214f293e0bf4cec"
    sha256                               arm64_monterey: "7d22e0d7fc49d4fa90e49e5bd7a6c1fc811535a4dc58cdaca5c869e0e6700ff1"
    sha256                               arm64_big_sur:  "b94b4041259f018b6be1d692a4d1f5f230eb4a7abd6bfa873625a3cb40aeb84c"
    sha256                               monterey:       "da1f86da3a5e3cbdb2fd0b533c1fb197e1092a01f489ba342c2795b7a3fea5a9"
    sha256                               big_sur:        "28cc7b74f3f542ec4b65fa1a8cef783c5bea9a0741181e7d9cf3a09f6fb79531"
    sha256                               catalina:       "9147cc1e6710408a47a45f0b7046997ad91414d45f8617bd90eeb8cdd9ba6365"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a056066cf147bb7b10ca3007fa479a0ab7e3bf6ff88d3e01ae10e1af678f2a5"
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
