class Libvidstab < Formula
  desc "Transcode video stabilization plugin"
  homepage "http://public.hronopik.de/vid.stab/"
  url "https://github.com/georgmartius/vid.stab/archive/v1.1.0.tar.gz"
  sha256 "14d2a053e56edad4f397be0cb3ef8eb1ec3150404ce99a426c4eb641861dc0bb"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any
    sha256 "20ea0ed1342cdc41222a0c47e785cfe3d2479f4b99108b56d0b93d8fb038c78c" => :catalina
    sha256 "fc020f4ca29d8aeaab68a06d7f182cd0e4261ad761fd2cbde64a028f77b28ba5" => :mojave
    sha256 "2d23e6352bda6577251800282d57be5520df2493a01a48d0f5716e1e1e95a465" => :high_sierra
    sha256 "5ff2357b04a9bb854b9a09d3b6974f7c665e032948a95981357bf62b857a4099" => :sierra
    sha256 "e3ed904feb361f98bc78ee3211ab6a13a4913f56e09213fecfb73f305c95dc45" => :el_capitan
    sha256 "f12257af2bbd99c395152638cb8a76e654a838072c55cb7a1cc25bacef632cc8" => :yosemite
  end

  depends_on "cmake" => :build

  # A bug in the FindSSE CMake script means that, if a variable is defined
  # as an empty string without quoting, it doesn't get passed to a function
  # and CMake throws an error. This only occurs on ARM, because the
  # sysctl value being checked is always a non-empty string on Intel.
  # Upstream PR: https://github.com/georgmartius/vid.stab/pull/93
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/5bf1a0e0cfe666ee410305cece9c9c755641bfdf/libvidstab/fix_cmake_quoting.patch"
    sha256 "45c16a2b64ba67f7ca5335c2f602d8d5186c29b38188b3cc7aff5df60aecaf60"
  end

  def install
    system "cmake", ".", "-DUSE_OMP=OFF", *std_cmake_args
    system "make", "install"
  end
end
