class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  # NOTE: Upstream often does not mark the latest release on GitHub, so
  #       this can be updated with the new tag.
  #       https://github.com/Homebrew/homebrew-core/pull/106939
  #       https://github.com/MaskRay/ccls/issues/786
  #       https://github.com/MaskRay/ccls/issues/895
  license "Apache-2.0"
  revision 2
  head "https://github.com/MaskRay/ccls.git", branch: "master"

  stable do
    url "https://github.com/MaskRay/ccls/archive/refs/tags/0.20250815.1.tar.gz"
    sha256 "b44d9f981e65dcf950525886f8211727da8a41d3070d323d558f950749bc493c"

    # Backport support for LLVM 22
    patch do
      url "https://github.com/MaskRay/ccls/commit/d31cc9f07668a91c892d5f13367b9a1e773fbe2b.patch?full_index=1"
      sha256 "13c2503f682d7b2932a2a4544f1fc32ace8799be9e9234b2f1df0867536a20fc"
      type :backport
    end

    # Backport support for LLVM 23
    patch do
      url "https://github.com/MaskRay/ccls/commit/e74892376d8a280c5ee99c19cb2349e6ca834bad.patch?full_index=1"
      sha256 "e1b6edd49d6e8dc7ed4d9955c094c32d2329ada2dc6fe4d2bf8e4347c7e778e8"
      type :backport
    end
  end

  bottle do
    sha256               arm64_golden_gate: "00c73884c75f67143adbcb31f30dc6e1219f5b9adfa887c05ad532c38cd6979e"
    sha256               arm64_tahoe:       "e25ee48292aa4b2b476a6c845dac5f23530c32d1397eef389ad69dcb69897ecb"
    sha256               arm64_sequoia:     "a596e973501d20652ce1bf2824b584da63ff97a9337a44c3db5e66d7a6f610da"
    sha256               arm64_sonoma:      "432eef0d92577797cb96c44b36664a5f40cfa5189a11851a7a98f06373e2a039"
    sha256               sonoma:            "6119e28d259e9856d6d12e00481d999fa24284f2ae8c70255c8df7a8db0e1ad9"
    sha256               arm64_linux:       "259a3754c16aae04226157300ffd44c71e2db952ef368db4d1aca40e85aa2e1b"
    sha256 cellar: :any, x86_64_linux:      "6f7cac8dbda0c13a28d4419df2c16c008e523c8888bd43e7de06c8968c279669"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm"

  def llvm
    deps.reject { |d| d.build? || d.test? }
        .map(&:to_formula)
        .find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: llvm.opt_lib)}" if OS.linux?
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
