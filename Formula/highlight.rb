class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-4.1.tar.bz2"
  sha256 "3a4b6aa55b9837ea217f78e1f52bb294dbf3aaf4ccf8a5553cf859be4fbf3907"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git"

  livecheck do
    url "http://www.andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "6727bd0348ec08e9855fd4574cf8a564d94cba5c3195f1bb9852f9733c351f08"
    sha256 arm64_big_sur:  "90c97137575b00aaa9050fb14f049e6b1dcfe236ae4266d7e684706f09a58f0f"
    sha256 monterey:       "4186adee8552304558aa2fd7af70db3355b92650564324b6cd02770bd22d4887"
    sha256 big_sur:        "e364d145b581f0622acf1cc9476142b8e318efa60495ca6e9c1f44ed560a2d66"
    sha256 catalina:       "4238b72def77283c7cedf385639bd9b28b5d0e3fb5d5c0bc6ec6fe6d06ae7bcf"
    sha256 mojave:         "81057a5898f59793eda32340275cb8bf87da61e6330bb5d0e925690c678b606b"
    sha256 x86_64_linux:   "f6f656122700a511ed946ca5a3d4db0e05db5c6f4f988567e866dfc50938a406"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # needs C++17

  def install
    conf_dir = etc/"highlight/" # highlight needs a final / for conf_dir
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}"
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}", "install"
  end

  test do
    system bin/"highlight", doc/"extras/highlight_pipe.php"
  end
end
