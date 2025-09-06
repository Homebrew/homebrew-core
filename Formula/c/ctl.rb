class Ctl < Formula
  desc "Programming language for digital color management"
  homepage "https://github.com/ampas/CTL"
  url "https://github.com/ampas/CTL/archive/refs/tags/ctl-1.5.4.tar.gz"
  sha256 "fb84925320d053827fce965d7aeea5bb8690d7093bb083c8e3915d7a600e25fc"
  license "AMPAS"
  revision 2
  head "https://github.com/ampas/CTL.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "db5e063fcfd89cf4b8c9273bf21bdc9c8e966318943aa3833482c0d49f54198c"
    sha256 cellar: :any,                 arm64_sonoma:  "ce1952823a31890334ca1473a1de258f7d85fa7081a9f7c798ee553f66113743"
    sha256 cellar: :any,                 arm64_ventura: "c8ae2967280c8efe51f1aa2139093e1692b53a7c3860d3722aa75a8ca0e520c9"
    sha256 cellar: :any,                 sonoma:        "e5292cf76de6a6edd88b63c011ac83c9db76dea99c1b9402238f8e4348366a44"
    sha256 cellar: :any,                 ventura:       "e85c76f90b9d3fb90164b3cc5551b89d8d367f1bf390b9cbe0ef8242dfb2d698"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "065461580cc518d5a13f44b3b6330988353f9de56309f39b5473874781a229f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "076e7df7853a39ef9f21ac0492f0f328aa1db171279ac28404493a35c3b3525f"
  end

  depends_on "cmake" => :build
  depends_on "aces_container"
  depends_on "imath"
  depends_on "libtiff"
  depends_on "openexr"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCTL_BUILD_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "transforms an image", shell_output("#{bin}/ctlrender -help", 1)
  end
end
