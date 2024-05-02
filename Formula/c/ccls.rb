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
  head "https://github.com/MaskRay/ccls.git", branch: "master"

  bottle do
    sha256                               arm64_sonoma:   "6ab9a1d2c36da592ca06025bd3b608cc27ba3b84cbc38ee8b217c2da0eb34fa6"
    sha256                               arm64_ventura:  "e80e46b44bf152f65e39f396122e0a855c6ae32591aa53713a56810ed09d8531"
    sha256                               arm64_monterey: "46d6b564cb66a364fd325cc142db5881c1d4962b4143bad775c12251199e8367"
    sha256                               sonoma:         "ec6fd6a7a732e644cb10a1cc7b87ed637cc3f43fb38f55daa55b6b3f0eea92d9"
    sha256                               ventura:        "144200f91337709f33db804efa14d89052a7a7da1f72005bc70ae8abe27932d5"
    sha256                               monterey:       "b19989185254ea8922725725a97d7aea3eddb1f11d322ab9ebd96cb4ed6b89e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b38297a355f3ccafce8ca86a31fdf274fbc09743c7fc6d50dc1c775af974c308"
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
