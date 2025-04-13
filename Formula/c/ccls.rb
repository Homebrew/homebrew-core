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
    url "https://github.com/MaskRay/ccls/archive/refs/tags/0.20241108.tar.gz"
    sha256 "76224663c3554eef9102dca66d804874d0252312d7c7d02941c615c87dcb68af"

    # Backport support for LLVM 20
    patch do
      url "https://github.com/MaskRay/ccls/commit/4331c8958698d42933bf4e132f8a7d61f3cedb8c.patch?full_index=1"
      sha256 "5420b53cf912268688953a2863e86f6b88334ed548852eaedb9f8ce4871ee034"
    end
  end

  bottle do
    sha256                               arm64_sequoia: "c27b908fad0df43a31ab3773116b623a5fbf118a6952fe107cf1b1ec74298fb9"
    sha256                               arm64_sonoma:  "c3f51b9b966652326d52e4f70ac9f76679e0f26cdbc217970869017f2496c389"
    sha256                               arm64_ventura: "d822534f47862b7b9bac59b251e365ff713bb236931a5a91f3d92f8e5a006d49"
    sha256                               sonoma:        "c55e6b6a3cb802ebc90911280ecc01729aa347818d854e2c2bb7d6fc73e8b7cf"
    sha256                               ventura:       "2821feb82b94d31af308fb656ac5354a720cf3faccc5aeae4efff119663932a2"
    sha256                               arm64_linux:   "76bba92dad7dd21c8fb560f4f41f5215043ef1ef8610ed34626a9f7bcdd5521b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aa50bc118e9e35d8840052839456fb362a603d5e04e210a6b8ae2df9da31423"
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
