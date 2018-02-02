class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.website"
  url "https://github.com/OpenRCT2/OpenRCT2/archive/v0.1.1.tar.gz"
  sha256 "5d7a6c7f3c770e7de506958f86789c438c543c27d312fd096322cde4e89f50ad"
  revision 1
  head "https://github.com/OpenRCT2/OpenRCT2.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "e78fe35236226bc462e2b9bab8acfba5481b5b2956e5d42c431b001249b8058a" => :high_sierra
    sha256 "735164169c25a89a67376f6f3214d8965f2f0bff76a7ae613aa62f81f89a9d75" => :sierra
    sha256 "8afca34c5907d09bbcae02a595fc4569c3176e666278c308ef99d01eeb07c64d" => :el_capitan
    sha256 "632e19d91eb45d75bfae015b1307adfb0173112652639d188c2b461acd61e9f5" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libpng"
  depends_on "libzip"
  depends_on "openssl"
  depends_on "sdl2"
  depends_on "sdl2_ttf"
  depends_on "speexdsp"
  depends_on "freetype" # for sdl2_ttf

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end

    # By default OS X build only looks up data in app bundle Resources
    libexec.install bin/"openrct2"
    (bin/"openrct2").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/openrct2" "$@" "--openrct-data-path=#{pkgshare}"
      EOS
  end

  test do
    assert_match /OpenRCT2, v#{version}/, shell_output("#{bin}/openrct2 -v")
  end
end
