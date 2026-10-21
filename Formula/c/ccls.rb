class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  # NOTE: Upstream often does not mark the latest release on GitHub, so
  #       this can be updated with the new tag.
  #       https://github.com/Homebrew/homebrew-core/pull/106939
  #       https://github.com/MaskRay/ccls/issues/786
  #       https://github.com/MaskRay/ccls/issues/895
  url "https://github.com/MaskRay/ccls/archive/refs/tags/0.20261004.tar.gz"
  sha256 "8e022718ac8d54aef36cd728a177ad036994d7abf535941b948ae14d1a9085dd"
  license "Apache-2.0"
  head "https://github.com/MaskRay/ccls.git", branch: "master"

  bottle do
    sha256               arm64_golden_gate: "8f12ed6eb82b8f87fb4dbacdb8eb3f1286b3b9b3a5d28668866ec77b83e236e4"
    sha256               arm64_tahoe:       "bf0d69403897572219e668f928febd2ca16eae7cfda186ebc756bc0d68433ce6"
    sha256               arm64_sequoia:     "5a7d2853fc6670d0810aeecf95057da60e85257e86cc7427a97402a1026598e0"
    sha256               arm64_linux:       "ed44add44f8f7b78b1171ae44f2eb0de162fb5900e1e48ecda66dca7da95a431"
    sha256 cellar: :any, x86_64_linux:      "8ee0086daee5b5875b374d6fded0d542a2ee4821a97bb900985603d52feec2ae"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm"

  def llvm
    deps.reject { |d| d.build? || d.test? }
        .find { |f| f.name.match?(/^llvm(@\d+)?$/) }
        .to_formula
  end

  deny_network_access!

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
