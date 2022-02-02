class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  url "https://github.com/MaskRay/ccls/archive/0.20210330.tar.gz"
  sha256 "28c228f49dfc0f23cb5d581b7de35792648f32c39f4ca35f68ff8c9cb5ce56c2"
  license "Apache-2.0"
  revision 4
  head "https://github.com/MaskRay/ccls.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "03499df1d40fa8aaea919f454c3ec0442369d7a07700239c19680ac859cc17da"
    sha256                               arm64_big_sur:  "5623cc1d2854b8dca70cf5024788fb7a108473b8880fe0167b149d669cde3a11"
    sha256                               monterey:       "36aab56bea2955b39d76264fccbec0c2b39e1e4543bf1c0207a17889d13b9d1f"
    sha256                               big_sur:        "9d3f9519a20be9a3f5a0f2d39175a10255f51ae55a77a9e45c2b83b19581d3ab"
    sha256                               catalina:       "730f87ef22eab330699cf415afbf41b632a685465cb6693330a21a1756479c11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23803b8edd700c197effc22a1aa4a640b2aa14e2e478cb0abc2d9c59b6a19470"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm"
  depends_on macos: :high_sierra # C++ 17 is required

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    resource_dir = Utils.safe_popen_read(Formula["llvm"].bin/"clang", "-print-resource-dir").chomp
    resource_dir.gsub! Formula["llvm"].prefix.realpath, Formula["llvm"].opt_prefix
    system "cmake", *std_cmake_args, "-DCLANG_RESOURCE_DIR=#{resource_dir}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/ccls -index=#{testpath} 2>&1")

    resource_dir = output.match(/resource-dir=(\S+)/)[1]
    assert_path_exists "#{resource_dir}/include"
  end
end
