class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  # NOTE: Upstream often does not mark the latest release on GitHub, so
  #       this can be updated with the new tag.
  #       https://github.com/Homebrew/homebrew-core/pull/106939
  #       https://github.com/MaskRay/ccls/issues/786
  #       https://github.com/MaskRay/ccls/issues/895
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/MaskRay/ccls/archive/refs/tags/0.20230717.tar.gz"
  sha256 "118e84cc17172b1deef0f9c50767b7a2015198fd44adac7966614eb399867af8"
  license "Apache-2.0"
  revision 1
  head "https://github.com/MaskRay/ccls.git", branch: "master"

  bottle do
    sha256                               arm64_sonoma:   "1e8428a18298b518d0b501d00ae12caf881e8ac2e259efd1d4f739bb921b98c2"
    sha256                               arm64_ventura:  "0f28cbeef439f2e41dca0596883ffa9b3e7346b31940dabec02edb34d0ab57ec"
    sha256                               arm64_monterey: "0b97c6471ce313aab1825af453825627cb98df4680ded949a6f2c6431f530816"
    sha256                               arm64_big_sur:  "7d3df565ce249c9a48e8b2518b40c90bc754804aeafcd7c25326d9f99a56070c"
    sha256                               sonoma:         "eca627049fe24744fdbf739f2012ba26183a3eb2a86fad672a3a998021540003"
    sha256                               ventura:        "fb7338b36e280fd289a83d830a39f93f244975be794252468c77d6accefcdcf8"
    sha256                               monterey:       "f3b6d17355b31ae1caf87aa392c7ff17d70ab6289a5d924fd5f7b6ef3125111c"
    sha256                               big_sur:        "1f32a422e5f1fa6eb5a3ffba9e08f034a41ee841154cdc24ba29c30377412454"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a405c9ede1c1366486b987bd99446c98dd41aaae2562755573570116f215a878"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm@16"
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
