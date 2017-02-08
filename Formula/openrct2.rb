class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.website"
  url "https://github.com/OpenRCT2/OpenRCT2/archive/v0.0.4.tar.gz"
  sha256 "ebcbbf1de3ccb76168535308ec9045271fae6c730bca4929575277f98deb40ab"

  bottle do
    cellar :any
    sha256 "4a8e954236100631e4dfcfef40a40a7a022f6c6844b1853650424ed99ab0a694" => :el_capitan
    sha256 "d0ab4dc42e818fdd6fd40c18ffb3032d58c5b7d76741f54742a11c0ebb00776b" => :yosemite
    sha256 "d9a744d07526bb96ecaf8e48e486b32127ba4a38261f4495e78b68c1d6eee643" => :mavericks
  end

  head do
    url "https://github.com/OpenRCT2/OpenRCT2.git", :branch => "develop"

    depends_on "openssl" => "universal"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson" => "universal"
  depends_on "libpng" => "universal"
  depends_on "sdl2" => "universal"
  depends_on "sdl2_ttf" => "universal"
  depends_on "speex" => "universal"

  depends_on "freetype" => "universal" # for sdl2_ttf
  depends_on "libogg" => "universal" # for speex
  depends_on "xz" => "universal" # for libpng

  def install
    ENV.m32
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
