class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.website"
  url "https://github.com/OpenRCT2/OpenRCT2/archive/v0.0.7.tar.gz"
  sha256 "cf35b6e058d675ae8369c9845f9c7c9e4269a1f4a57da91dcdcdcde7e608adac"
  head "https://github.com/OpenRCT2/OpenRCT2.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "63499f130b12f8ee7698d0822c2437ade72dc23a92c87b1c87f4d4dcd8568127" => :sierra
    sha256 "cd7102e02ea38266a85a52aba741d1682198423ac77ab24cf186ee0e41b099aa" => :el_capitan
    sha256 "daec48d326834a85450afaf275b5f1fce5f49bb4aec1543f5bd8287f761f68c8" => :yosemite
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
