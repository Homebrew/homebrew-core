class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  # NOTE: Upstream often does not mark the latest release on GitHub, so
  #       this can be updated with the new tag.
  #       https://github.com/Homebrew/homebrew-core/pull/106939
  #       https://github.com/MaskRay/ccls/issues/786
  #       https://github.com/MaskRay/ccls/issues/895
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/MaskRay/ccls/archive/refs/tags/0.20240202.tar.gz"
  sha256 "355ff7f5eb5f24d278dda05cccd9157e89583272d0559d6b382630171f142d86"
  license "Apache-2.0"
  revision 1
  head "https://github.com/MaskRay/ccls.git", branch: "master"

  bottle do
    sha256                               arm64_sonoma:   "7492cb5f43e3bf65ec1a6a8aa9d24151154b02df4c63c2a791bf495b08d65a61"
    sha256                               arm64_ventura:  "5b3c4f1003dcad16b0221032aebd2793dea4efb500678668dedcaa118870df69"
    sha256                               arm64_monterey: "998e41d641b206a6bfeae293dae477f08a802c5b0bf368e487e7b8b504d9f1d0"
    sha256                               sonoma:         "417b048477613be53f4aeb16b11cd60da20163342f6643d108256325f52825b0"
    sha256                               ventura:        "a9099ef1c527080d63783fc4620850e7bc2d93061e84c54aa706da49d024932d"
    sha256                               monterey:       "89adaa6d420d1f21b4a176fb77ddc1236e0a102009956b5ac0efd6eb6844cd5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26999d25d86872987728832416459e7291fd221f916fe7678a6af06b11623150"
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
