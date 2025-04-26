class Iccmax < Formula
  desc "Reference implementation tools for iccMAX"
  homepage "https://github.com/InternationalColorConsortium/DemoIccMAX"
  url "https://github.com/InternationalColorConsortium/DemoIccMAX/archive/9f4cc3b1b5446b87c22695e44ef25a1e25c4e4a3.tar.gz"
  version "2.1.26"
  sha256 "8eb4e854f99ed52cd8fc19dbf8b5d045e4db69c09cbe837702a6bad915e7ecbc"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "nlohmann-json"
  depends_on "wxwidgets"
  uses_from_macos "libxml2"

  def install
    mkdir "Build" do
      rpath = opt_lib.to_s
      system "cmake", "../Build/Cmake", "-DCMAKE_INSTALL_PREFIX=#{prefix}",
                                         "-DCMAKE_BUILD_TYPE=Release",
                                         "-DCMAKE_INSTALL_RPATH=#{rpath}",
                                         "-DENABLE_TOOLS=ON",
                                         "-DENABLE_SHARED_LIBS=ON",
                                         "-DENABLE_STATIC_LIBS=ON",
                                         "-DENABLE_TESTS=ON",
                                         "-DENABLE_INSTALL_RIM=ON",
                                         "-DENABLE_ICCXML=ON",
                                         "-Wno-dev"
      system "make", "-j#{ENV.make_jobs}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/iccDumpProfile", "--help"
  end
end
