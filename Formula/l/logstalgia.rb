class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "https://logstalgia.io/"
  url "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.1.5/logstalgia-1.1.5.tar.gz"
  sha256 "028936e9f663c877d6969ad25f145c7b420797e9a3e01c6c184815ed8309f481"
  license "GPL-3.0-or-later"
  head "https://github.com/acaudwell/Logstalgia.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "2bcc3f749465347934eceb6ec6922c9c927e7b8bc04513a263c58e8b69615a87"
    sha256 arm64_sequoia: "565194f69d3392f0e853b8a317e7e7059ebb68db16ae0da0a12c0c61c50097d6"
    sha256 arm64_sonoma:  "415cff96d89ec355c65757dbd695e25895f8326e9b4d3acb140ff3724efb339c"
    sha256 sonoma:        "eeabaeaedb6aa408ffa0d3248d69fb91230c36363b40e872a8248aa9dd109e6b"
    sha256 arm64_linux:   "a9847ee898ca58d0f4f77492b5fe95428a9ded03a01da144098d7c2275636cfb"
    sha256 x86_64_linux:  "2a9a18916c48cf23d57b90db044357e2283c8ca13c7956467257a153a09ad692"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "glm" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre2"
  depends_on "sdl2"
  depends_on "sdl2_image"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    ENV.cxx11 # to build with boost>=1.85

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Logstalgia v1.", shell_output("#{bin}/logstalgia --help")
  end
end
