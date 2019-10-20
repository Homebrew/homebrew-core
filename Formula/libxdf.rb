class Libxdf < Formula
  desc "C++ library for loading XDF files"
  homepage "https://github.com/Yida-Lin/libxdf"
  url "https://github.com/xdf-modules/libxdf/archive/v0.99.tar.gz"
  sha256 "af66f6c1be5d9342fa33bc2a3b34c5a962db37d10623df57d352a213fe5201d1"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"

    include.mkpath
    include.install "./xdf.h"
    lib.mkpath
    if OS.mac?
      lib.install "libxdf.dylib"
    else
      lib.install "libxdf.so"
    end
    lib.install "libxdf.a"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test biosig4c%2B%2B`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "ls", "#{lib}/libxdf.*"
  end
end
