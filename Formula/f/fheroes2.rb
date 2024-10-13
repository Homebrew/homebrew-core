class Fheroes2 < Formula
  desc "Recreation of the Heroes of Might and Magic II game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/refs/tags/1.1.2.tar.gz"
  sha256 "2c1ecc167de9b4a5f0eb6b6c88392ba021b4e031844760611067971e71e58b6d"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "b43c8c4af2e91e1076891492b66de8db17e6d2374b84d9f284c249191dda44c5"
    sha256 arm64_sonoma:  "1f24eaa709448375741122f51f22bb234462c92cd90b41455a0ba3aa2b75f9bd"
    sha256 arm64_ventura: "c511e61f3941660653997de4dfb4237ba5757a43f44ddeef3b2e9fb783e858d9"
    sha256 sonoma:        "fa07c89b98c6fa84a3c1c0307543cd368399ef73c4e1f195eff535d7199e744d"
    sha256 ventura:       "754576a4078b46907bfa927da2d59a311997f96eda27dba30323e0e8c9b8bcbc"
    sha256 x86_64_linux:  "b7d17c758434be4241622c577a9e0ec15a9b32ef019d94da89458802421ca493"
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
