class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  # NOTE: Upstream often does not mark the latest release on GitHub, so
  #       this can be updated with the new tag.
  #       https://github.com/Homebrew/homebrew-core/pull/106939
  #       https://github.com/MaskRay/ccls/issues/786
  #       https://github.com/MaskRay/ccls/issues/895
  license "Apache-2.0"
  revision 1
  head "https://github.com/MaskRay/ccls.git", branch: "master"

  stable do
    url "https://github.com/MaskRay/ccls/archive/refs/tags/0.20250815.1.tar.gz"
    sha256 "b44d9f981e65dcf950525886f8211727da8a41d3070d323d558f950749bc493c"

    # Backport support for LLVM 22
    patch do
      url "https://github.com/MaskRay/ccls/commit/d31cc9f07668a91c892d5f13367b9a1e773fbe2b.patch?full_index=1"
      sha256 "13c2503f682d7b2932a2a4544f1fc32ace8799be9e9234b2f1df0867536a20fc"
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "828f8f022c4d2d28a12e5f21e58ba81c43e6800e243ca23168a255dcebab8725"
    sha256                               arm64_sequoia: "abff16b5beb658a167a6a9f23b8e89634c1eabf4b30f76335fac35be7e8f1301"
    sha256                               arm64_sonoma:  "046d68534f7476f7b65cf6df4f036bc0920e7d1adcd42ebea40b159e6f174dab"
    sha256                               sonoma:        "e3674eb35881af0ba202937b1bea6949533982fd150492b0efaa7e4ada1db537"
    sha256                               arm64_linux:   "1a7cc23edfbe66b0582a9a2c802c79cf08fad134a1160e30d5be6e4b70c64a4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d436bec5d893d5b61d6c43fe7e64d716475a20961e56a35b3d4c4db467e91a0"
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
