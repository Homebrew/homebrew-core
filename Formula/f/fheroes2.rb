class Fheroes2 < Formula
  desc "Free Heroes of Might and Magic II is a recreation of HoMM2 game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/1.0.9.tar.gz"
  sha256 "22e73ee4ff8a38e9e648fcb8df681fbb309b136e68483639517dfc9f61f867df"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "5bc32db2fd0b0e3a0858dc723834edd0bbcf9ab0bdbbd420a9a7a6cae0bba19c"
    sha256 arm64_ventura:  "7130860f665b300167bf5d571444b48bcdac1468aa565cf2cf7e1963de006037"
    sha256 arm64_monterey: "5c7df58c5983f192709955357ad50f7468eb3edd022a0786134f221cb42beaf3"
    sha256 sonoma:         "3078f147141ce141f346d649de89f307c0910c4bb6fbb79f1969a9688c2f5117"
    sha256 ventura:        "5e0d09d2eebb21548d86c57b1c72e8d41a824727e6c1b42aef8530f329bc262f"
    sha256 monterey:       "1c815d536ae714edc71761b8eec0032171981e1715c7bc9037639429c601a57b"
    sha256 x86_64_linux:   "2fb8f9f0ce678d9be88e2bcc840481688cd20b6be59c2e786f27b99b5e7d3d49"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  depends_on "libpng"
  depends_on "sdl2"
  depends_on "sdl2_image"
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
