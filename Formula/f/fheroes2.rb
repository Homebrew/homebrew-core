class Fheroes2 < Formula
  desc "Recreation of the Heroes of Might and Magic II game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/refs/tags/1.1.0.tar.gz"
  sha256 "df46c5fe702e71022974db8247aba49fb64693e4b967b68bae16872fba875542"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "1160e847c46e2b22df2a110648634ddbfcb6e391c00d5e3d5b7dabd76f8d2455"
    sha256 arm64_ventura:  "54bdacbf958eee6c69052bacf7ff79fb759f9125900a57762dadd5eb03efb5ea"
    sha256 arm64_monterey: "e8694a04ceb36b925810be0f9441908edf60c1d87cee6dfc933911dc46e41f0c"
    sha256 sonoma:         "d3d0476bf1c90409d92a5c754b0a0911d904f53238609e6d4bffea2676941364"
    sha256 ventura:        "cd7fa7adce3aaa62f5836a212dc5ea09b0aa9c7f4e1a11c407f7eb794487c923"
    sha256 monterey:       "d1c0ec809d5fb7935a734265ab74de9cbe0b1ba9cc76778d7d8d1145c8ffc333"
    sha256 x86_64_linux:   "5ff10ee3685c09eeffd28350a07e9f3fa5897f1e4900a7ae83d1210b23c4cf34"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  depends_on "innoextract"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.install "script/demo/download_demo_version.sh" => "fheroes2-install-demo"
    bin.install "script/homm2/extract_homm2_resources.sh" => "fheroes2-extract-resources"
  end

  def caveats
    <<~EOS
      Documentation is available at:
      #{share}/doc/fheroes2/README.txt
    EOS
  end

  test do
    io = IO.popen("#{bin}/fheroes2 2>&1")
    io.any? do |line|
      line.include?("fheroes2 engine, version:")
    end
  end
end
