class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.website"
  url "https://github.com/OpenRCT2/OpenRCT2/archive/v0.0.7.tar.gz"
  sha256 "cf35b6e058d675ae8369c9845f9c7c9e4269a1f4a57da91dcdcdcde7e608adac"
  revision 1
  head "https://github.com/OpenRCT2/OpenRCT2.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "aa61b55edae1e172c9d1628003c568baef7d3d8d29c4a8e35d2ee7b980f9143c" => :sierra
    sha256 "138836e72147cc12d4f4dc07c832a520d97d90cb22d34383e9f934f4a02210dd" => :el_capitan
    sha256 "8646db1e5ae01b654c3d4215f5a8b58e64a76013f4e773cf604bc3f1dfca590f" => :yosemite
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
    (bin/"openrct2").write <<-EOS.undent
      #!/bin/bash
      exec "#{libexec}/openrct2" "$@" "--openrct-data-path=#{pkgshare}"
      EOS
  end

  test do
    assert_match /OpenRCT2, v#{version}/, shell_output("#{bin}/openrct2 -v")
  end
end
