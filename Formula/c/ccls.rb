class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  # NOTE: Upstream often does not mark the latest release on GitHub, so
  #       this can be updated with the new tag.
  #       https://github.com/Homebrew/homebrew-core/pull/106939
  #       https://github.com/MaskRay/ccls/issues/786
  #       https://github.com/MaskRay/ccls/issues/895
  url "https://github.com/MaskRay/ccls/archive/refs/tags/0.20250815.1.tar.gz"
  sha256 "b44d9f981e65dcf950525886f8211727da8a41d3070d323d558f950749bc493c"
  license "Apache-2.0"
  head "https://github.com/MaskRay/ccls.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "d41a620c124d28b837a29cfec3e13876930ae1e009e418288fc88999e32b6e27"
    sha256                               arm64_sequoia: "749dfea1d4613ad31cd9fb75a6453abcf2a4255583d34725875b628e28a5a2c4"
    sha256                               arm64_sonoma:  "6efb922e55abc89e8692f01983fb0535aba8c98ff1f44d955b2a1f2c2009335f"
    sha256                               sonoma:        "45f103aff2b44c753aea52f1029069d9e07411b71fe406646bb4a1b1d26ff45f"
    sha256                               arm64_linux:   "fa9463f30db82918f4ac61bfd4874ad5edc7e64602fd914cb64a54b7474c838e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ec6d7f2aaecfb5a5489a51020a06b6898c82b2e7597b47baec619f88eca9a06"
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
