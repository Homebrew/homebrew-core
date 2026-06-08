class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v4.8.0.tar.gz"
  sha256 "91f113be2bf8385ae5c42979fd36619f93473bfe0c763e952c236dbac63dd9c0"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 arm64_tahoe:   "fcaadf7d51c19813a01eb597b70c208061bdef07d2017b5c61e925c2dfa4d968"
    sha256 arm64_sequoia: "0dd1f7f626422be6665b47f713350335049dc404b0f21dc5078e159c99f53e2d"
    sha256 arm64_sonoma:  "01627d98d6cc77292979386512fa62b8fb4beae86bcc9d21ad28c5636b54943d"
    sha256 sonoma:        "18eb1ef39e70f577d65e769bc77ecd173d4fae13c1a083b11e229c3be9f2df63"
    sha256 arm64_linux:   "e9385fbaa34cd996a8c1eefd06ca8dddd41100a4be599240f6d06e9897d2b336"
    sha256 x86_64_linux:  "68f556d944223eb275470501808eba33c936369a2cec586b04c683f5e9c09537"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libre"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{Formula["libre"].opt_include}/re
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
