class Cataclysm < Formula
  desc "Fork/variant of Cataclysm Roguelike"
  homepage "https://github.com/CleverRaven/Cataclysm-DDA"
  url "https://github.com/CleverRaven/Cataclysm-DDA/archive/0.C.tar.gz"
  version "0.C"
  sha256 "69e947824626fffb505ca4ec44187ec94bba32c1e5957ba5c771b3445f958af6"

  head "https://github.com/CleverRaven/Cataclysm-DDA.git"

  bottle do
    cellar :any
    sha256 "1a821cdc40c5170e95c32877acdeb086fedecf366a505e27c559c557003b31de" => :sierra
    sha256 "939d8b6b945457b91f77860f31675d9facf57a842e1b033ea4ed889ee91ab165" => :el_capitan
    sha256 "e7ea748e9dd53bd0ace6c8456c4eb351616dc9c879621b6724ce742ae2b0d4f2" => :yosemite
  end

  option "with-tiles", "Enable tileset support"

  needs :cxx11

  depends_on "gettext"

  if build.with? "tiles"
    depends_on "sdl2"
    depends_on "sdl2_image"
    depends_on "sdl2_ttf"
  end

  def install
    ENV.cxx11

    args = %W[
      NATIVE=osx RELEASE=1 OSX_MIN=#{MacOS.version}
    ]

    args << "TILES=1" if build.with? "tiles"
    args << "CLANG=1" if ENV.compiler == :clang

    system "make", *args

    # no make install, so we have to do it ourselves
    if build.with? "tiles"
      libexec.install "cataclysm-tiles", "data", "gfx"
    else
      libexec.install "cataclysm", "data"
    end

    inreplace "cataclysm-launcher" do |s|
      s.change_make_var! "DIR", libexec
    end
    bin.install "cataclysm-launcher" => "cataclysm"
  end
end
