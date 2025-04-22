class Fheroes2 < Formula
  desc "Recreation of the Heroes of Might and Magic II game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/refs/tags/1.1.7.tar.gz"
  sha256 "6419ad0bd0f1f684a9256c39fb6c02a026fc76581b0bc9632a597fbc8443fc03"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "923052a337d4f1c2fb9fda17c0583db1838d9e69c7ee21ff952baf7728444581"
    sha256 arm64_sonoma:  "dd0f91994a1b6a2ba399305894eeef5787c4a4815e0182243b80a38a8ee4e667"
    sha256 arm64_ventura: "489962fc4e969c04ed374647abc303f0138280512d16671dcc3732857315b192"
    sha256 sonoma:        "44440672a2b1da48ed6288afad3a4dea7e9d9507d1a4d340b728f78876d8cb08"
    sha256 ventura:       "a76fa029a98145dca97759a6e66188f143ef8400da6963011858f7b293acd368"
    sha256 arm64_linux:   "a3b80cc8e2137752d68056e0827e672b7e3eed19b740018b4b94512801fa5a23"
    sha256 x86_64_linux:  "b0001f5a990deaeaae3f6b4bd1927a198caf29a13b95f45b64827cf383e4a6b0"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  depends_on "innoextract"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.install "script/demo/download_demo_version.sh" => "fheroes2-install-demo"
    bin.install "script/homm2/extract_homm2_resources.sh" => "fheroes2-extract-resources"
  end

  def caveats
    <<~EOS
      Run fheroes2-install-demo command to download and install all the necessary
      files from the demo version of the original Heroes of Might and Magic II game.

      Run fheroes2-extract-resources command to extract all the necessary resource
      files from a legally purchased copy of the original game.

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
