class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.website"
  url "https://github.com/OpenRCT2/OpenRCT2/archive/v0.1.1.tar.gz"
  sha256 "5d7a6c7f3c770e7de506958f86789c438c543c27d312fd096322cde4e89f50ad"
  revision 1
  head "https://github.com/OpenRCT2/OpenRCT2.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "b334e1d1e0b847c7739538f6f24431cd3cd9bdecaabff753a233c3c5453b4bb0" => :high_sierra
    sha256 "1d43828de7df01c6ae811fd9934ad64e924c864c7603d289dc3beeb4ba87cd91" => :sierra
    sha256 "723d04c2e90c75ecd49b53e90e7eb28fec4ba3d0a6d0cba8988f7b08f9e8d0b7" => :el_capitan
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
