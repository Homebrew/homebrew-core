class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  # NOTE: Upstream often does not mark the latest release on GitHub, so
  #       this can be updated with the new tag.
  #       https://github.com/Homebrew/homebrew-core/pull/106939
  #       https://github.com/MaskRay/ccls/issues/786
  #       https://github.com/MaskRay/ccls/issues/895
  url "https://github.com/MaskRay/ccls/archive/refs/tags/0.20240505.tar.gz"
  sha256 "4ea6d90a9f93d5503e59c3bd0e5568ab262ff3dcf1b7539b50a0ede4a0e32fea"
  license "Apache-2.0"
  head "https://github.com/MaskRay/ccls.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "dd72e908ed43995d6078af01f9f8021cc61799445271d3a040e63e056b230a7f"
    sha256                               arm64_sonoma:  "d150928cd70c213296534660ec53275dd35434863c11546978b19be11ba8078e"
    sha256                               arm64_ventura: "ceff1c27a290bce123dab0bdf9b15644b372f6f2d4c14a03104a01bd13eccd40"
    sha256                               sonoma:        "74a2bbdcfd5fe6ed74bc05e17af99edd7ca22e0d264d71aa4624e2c64f60cc95"
    sha256                               ventura:       "cdfec2cf7d5027ac4ebf5dc41ffac54b2a41c8a14fe55a02f8c7edffaa96a867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30f6d1754edadb51e6f534c6624b00af338e61fca00abfbf2b296522c356b14a"
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
