class Macaulay2 < Formula
  @name = "M2"
  desc "Software system for algebraic geometry research"
  homepage "http://macaulay2.com"
  url "https://github.com/Macaulay2/M2.git", :using => :git, :branch => "release-1.16"
  version "1.16"
  license "GPL-3.0"
  revision 1

  head do
    url "https://github.com/Macaulay2/M2.git", :using => :git, :branch => "development"
  end

  # autoconf, automake, and libtool are required to build
  # libraries not available via brew, such as factory
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  # libraries available via brew
  depends_on "bdw-gc"
  depends_on "boost"
  depends_on "cddlib"
  depends_on "eigen"
  depends_on "flint"
  depends_on "gdbm"
  depends_on "glpk"
  depends_on "gmp"
  depends_on "libatomic_ops"
  depends_on "libomp"
  depends_on "libxml2"
  depends_on "mpfr"
  depends_on "ntl"
  depends_on "openblas"
  depends_on "readline"
  depends_on "tbb"

  def install
    build_path = "M2/BUILD/brew"
    extra_args = ["-GNinja", "-DUSING_MPIR=OFF", "-DBLA_VENDOR=OpenBLAS", "-DCMAKE_INSTALL_LIBDIR=lib"]

    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    ENV["SDKROOT"] = MacOS.sdk_path

    system "cmake", "-SM2", "-B#{build_path}", *std_cmake_args, *extra_args
    system "cmake", "--build", build_path, "--target", "build-libraries", "build-programs"
    system "cmake", "--build", build_path, "--target", "M2-core", "M2-emacs"
    system "cmake", "--build", build_path, "--target", "install-packages"
    system "cmake", "--install", build_path
  end

  test do
    system "#{bin}/M2", "--version"
    system "#{bin}/M2", "--check", "1", "-e", "exit 0"
  end
end
