class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v4.13.0.tar.gz"
  sha256 "688dbb92844340c2dd8dab7d93aaebccb3aa433af9215bb099ca598fafc0e0a2"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_golden_gate: "6aeb7a185595ea5cc105d40e0d559a5a7d137d86435ecd284dea0ba1db14b28c"
    sha256 arm64_tahoe:       "feac662a7fc29c3c36c9073d3f669431c1f5e75dadc0faea4b756b556f471a2e"
    sha256 arm64_sequoia:     "dd7e8aa9e2af2334577138bf8454d55a1471b8dd16ff86ce0368c37e52ba97bc"
    sha256 arm64_linux:       "623c9f507dbbee2de2cb7fa40ee73a71621d2f61ed4055a0a35f049afa7b7332"
    sha256 x86_64_linux:      "5801193d47d068327a59d69fd1df41d7bbdd8013d94554daf531e4ec16e23bb6"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libre"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{formula_opt_include("libre")}/re
    ]
    args += %w[EXE SHARED].map { |type| "-DCMAKE_#{type}_LINKER_FLAGS=-Wl,-dead_strip_dylibs" } if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end
