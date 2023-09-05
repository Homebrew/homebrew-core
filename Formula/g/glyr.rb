class Glyr < Formula
  desc "Music related metadata search engine with command-line interface and C API"
  homepage "https://github.com/sahib/glyr"
  url "https://github.com/sahib/glyr/archive/1.0.10.tar.gz"
  sha256 "77e8da60221c8d27612e4a36482069f26f8ed74a1b2768ebc373c8144ca806e8"
  license "LGPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0b11085d86604b659fe43f99e91838695ff2c6bb4a1e5f2790e6af6fc90246da"
    sha256 cellar: :any,                 arm64_monterey: "800ed9d047c06e8490f6318b36c88c34feb4dac7dbe60a539edd752f4568a08e"
    sha256 cellar: :any,                 arm64_big_sur:  "498252c79958a96c42f3bea2936366f692d5c25cf12d6b3ee3c8ac1a5747f4b8"
    sha256 cellar: :any,                 ventura:        "5c2a9dbf3b8f41d091f36b78e8c5597fe3ec3f5153eb5d60577b911b92d6a68b"
    sha256 cellar: :any,                 monterey:       "ff357ecf355067543f989182c6dc6a113d0aa64dca00aa3df67a080d68ba2ca5"
    sha256 cellar: :any,                 big_sur:        "86ce9cf96d67fdbe9b174f4bc302f9c31abffcfb7790ec07fef5294f66beca17"
    sha256 cellar: :any,                 catalina:       "9ef809e699349c1fa1bb8e83f23aee567d1de60af6ddd7bef19409ecd58f8cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f147edbece71a6cac950c74f75b974da8d821139fbe1db95faeb0e08b67182af"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  uses_from_macos "curl"
  uses_from_macos "sqlite"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    search = "--artist Beatles --title 'Eight Days A Week'"
    cmd = "#{bin}/glyrc lyrics --no-download #{search} -w stdout"
    assert_match "Love you all the time", pipe_output(cmd, nil, 0)
  end
end
