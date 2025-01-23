class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  # NOTE: Upstream often does not mark the latest release on GitHub, so
  #       this can be updated with the new tag.
  #       https://github.com/Homebrew/homebrew-core/pull/106939
  #       https://github.com/MaskRay/ccls/issues/786
  #       https://github.com/MaskRay/ccls/issues/895
  url "https://github.com/MaskRay/ccls/archive/refs/tags/0.20241108.tar.gz"
  sha256 "76224663c3554eef9102dca66d804874d0252312d7c7d02941c615c87dcb68af"
  license "Apache-2.0"
  head "https://github.com/MaskRay/ccls.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "ece6c26479841524dee0e88a2bf2a777b2574467634a97d97d24faeb727105cc"
    sha256                               arm64_sonoma:  "e9df0aaf48436855c03f38a7119c9d907c06965a57274fc5448e909ec8e1254a"
    sha256                               arm64_ventura: "0f697d60ca786fc5c27e35d9d00fffffcb0d0b72d5344d6d8bd3708c0ebb64d4"
    sha256                               sonoma:        "0c9bbd4d249e1798109104f2952ca47e80e50b68f4203d2641bd5d41e867c8b2"
    sha256                               ventura:       "6715ce158c2e09795f2d083013bbdf0ca3aa6d3399d91946d3db786decadead4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4e878b4bccc6d9e2a5c50e06ddf834c1a4c7de4ca1e64d4f4961ceb4ef36993"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm"
  depends_on macos: :high_sierra # C++ 17 is required

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
