class Musikcube < Formula
  desc "Terminal-based audio engine, library, player and server"
  homepage "https://musikcube.com"
  url "https://github.com/clangen/musikcube/archive/0.99.8.tar.gz"
  sha256 "7209a875851e03ce89db3e2150ed3c1fabec5d39c0adfd74e2f37b7b2d180f48"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/clangen/musikcube.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "b325aada188757a94336cf1cb08006d770972f6c3ef120f9d9a6f020d056cbd3"
    sha256 arm64_monterey: "c59ffe20a29f366f3fdd4565bb7a1a23eeeb9e64c818fcd14a7e8752ac4ecadd"
    sha256 arm64_big_sur:  "28d1c5f2a7d117a6638184e83aa5ddc81baf41b9b390c366264c48da84daa3d9"
    sha256 ventura:        "0afa7c909bc06413489ea7331afc2247544e79ab7a9682dee60444eab1ae30cd"
    sha256 monterey:       "257e5e3d9d230c792e238923a2a254d65c0eb09f779b458353888bd9f26edd2d"
    sha256 big_sur:        "6bed0381821ea2c9dc7c89add2faf7920cc6108c68622deb841c6822d2074611"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "game-music-emu"
  depends_on "gnutls"
  depends_on "lame"
  depends_on "libev"
  depends_on "libmicrohttpd"
  depends_on "libogg"
  depends_on "libopenmpt"
  depends_on "libvorbis"
  depends_on :macos
  depends_on "ncurses"
  depends_on "openssl@1.1"
  depends_on "taglib"
  uses_from_macos "curl"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"musikcubed", "--start"
    system "sleep", "5"
    assert_path_exists "/tmp/musikcubed.lock"
    system "sleep", "5"
    system bin/"musikcubed", "--stop"
  end
end
