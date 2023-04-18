class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/gammaray"
  url "https://github.com/KDAB/GammaRay/releases/download/v2.11.3/gammaray-2.11.3.tar.gz"
  sha256 "03d7ca7bd5eb600c9c389d0cf071960330592f1f392a783b7fec5f9eaa5df586"
  license "GPL-2.0-or-later"
  head "https://github.com/KDAB/GammaRay.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "d6c6176b66638be42f13801d7656142157daffdfbf384bd39033851b3a48cafb"
    sha256 cellar: :any,                 arm64_monterey: "e84fc150dc66a7e32b44546f038cb32bb156aae65688f14055f4182fa9cba79d"
    sha256 cellar: :any,                 arm64_big_sur:  "7de52e10f8bbe77f1104f358602c4b25613c8f9d874d5ab2fa53828941cb1e23"
    sha256 cellar: :any,                 ventura:        "ce96ecccdb25b4e68292d30ae7f78deb57fa744f42f5f5c28cfff0ad990952a0"
    sha256 cellar: :any,                 monterey:       "f7e0316e417b5e6518acf88f61615cc274a7724bff18e5a7c923fd0af1684c49"
    sha256 cellar: :any,                 big_sur:        "0d62f89cc2cd25a325d136fe6d2989d449265b01c023369da60b94955bafa58f"
    sha256 cellar: :any,                 catalina:       "355dff5be6e35a6d5e4bb182d63eb88813c6db74b196b49109513612a7406b84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4872f5bb91e7ecc4589bcad43a2cabef330548c52e89413fd0d9c8e8c0676ab2"
  end

  depends_on "cmake" => :build
  depends_on "graphviz"
  depends_on "qt@5"

  fails_with gcc: "5"

  def install
    # For Mountain Lion
    ENV.libcxx

    system "cmake", *std_cmake_args,
                    "-DCMAKE_DISABLE_FIND_PACKAGE_Graphviz=ON",
                    "-DCMAKE_DISABLE_FIND_PACKAGE_VTK=OFF"
    system "make", "install"
  end

  test do
    gammaray = OS.mac? ? prefix/"GammaRay.app/Contents/MacOS/gammaray" : bin/"gammaray"
    assert_predicate gammaray, :executable?
  end
end
