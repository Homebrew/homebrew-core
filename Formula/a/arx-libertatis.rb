class ArxLibertatis < Formula
  desc "Cross-platform, open source port of Arx Fatalis"
  homepage "https://arx-libertatis.org/"
  url "https://arx-libertatis.org/files/arx-libertatis-1.2.1/arx-libertatis-1.2.1.tar.xz"
  sha256 "aafd8831ee2d187d7647ad671a03aabd2df3b7248b0bac0b3ac36ffeb441aedf"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://arx-libertatis.org/files/"
    regex(%r{href=["']?arx-libertatis[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "5325804c370afdd20735e1f3545ed751228d016336b0d8bc09dea5738aff3382"
    sha256 arm64_sequoia: "a0fb68a8fd8a4edb0fb94e166822b1a8e6784ac8c8fb351a11d315bfeecd962b"
    sha256 arm64_sonoma:  "f68e8dded909bccda04287d05d270f48195f4f076d2f5b63a1c3697dff92f8ad"
    sha256 sonoma:        "eb40806b957db79e99ab61669e727f9f3bdf01b6cd7691875c0552690c5e1ee1"
    sha256 arm64_linux:   "644ef946e42f76855bda8c30582856a4f92b11f4c71d11e280a7e908e6dbb0f2"
    sha256 x86_64_linux:  "4d28da523e6f47582e5a9c9862f8e9acc9caf70edb15f74b082c882ffcbeb259"
  end

  head do
    url "https://github.com/arx/ArxLibertatis.git", branch: "master"

    resource "arx-libertatis-data" do
      url "https://github.com/arx/ArxLibertatisData.git", branch: "master"
    end
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "glm" => :build
  depends_on "freetype"
  depends_on "glew"
  depends_on "innoextract"
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
    depends_on "openal-soft"
  end

  conflicts_with "rnv", because: "both install `arx` binaries"

  def install
    args = %w[
      -DBUILD_CRASHREPORTER=OFF
      -DSTRICT_USE=ON
      -DWITH_OPENGL=glew
      -DWITH_SDL=2
    ]

    # Install prebuilt icons to avoid inkscape and imagemagick deps
    if build.head?
      (buildpath/"arx-libertatis-data").install resource("arx-libertatis-data")
      args << "-DDATA_FILES=#{buildpath}/arx-libertatis-data"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      This package only contains the Arx Libertatis binary, not the game data.
      To play Arx Fatalis you will need to obtain the game from GOG.com and
      install the game data with:

        arx-install-data /path/to/setup_arx_fatalis.exe
    EOS
  end

  test do
    output = shell_output("#{bin}/arx --list-dirs")
    assert_match "User directories (select first existing)", output
  end
end
