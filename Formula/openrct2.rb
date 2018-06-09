class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2/archive/v0.1.2.tar.gz"
  sha256 "358fc0ceff848734b399dc63c1d7a0c096a54a793afe4522d6f0dd00ba9328c7"
  head "https://github.com/OpenRCT2/OpenRCT2.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "a2a31260b0c6fb1d780945f9a8517fc7bc0a832e7aadb5aeda5ff5f4517071b3" => :high_sierra
    sha256 "3f50413762987b388ba37939734339369875e746079bbbc840a2d640c65dde39" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libpng"
  depends_on "libzip"
  depends_on :macos => :sierra # undefined symbol ___cpu_model on El Capitan
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
