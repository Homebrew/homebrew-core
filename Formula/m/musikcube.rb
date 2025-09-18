class Musikcube < Formula
  desc "Terminal-based audio engine, library, player and server"
  homepage "https://musikcube.com"
  license all_of: [
    "BSD-3-Clause",
    "GPL-2.0-or-later", # src/plugins/supereqdsp/supereq/
    "LGPL-2.1-or-later", # src/plugins/pulseout/pulse_blocking_stream.c (Linux)
    "BSL-1.0", # src/3rdparty/include/utf8/
    "MIT", # src/3rdparty/include/{nlohmann,sqlean}/, src/3rdparty/include/websocketpp/utf8_validator.hpp
    "Zlib", # src/3rdparty/include/websocketpp/base64/base64.hpp
    "bcrypt-Solar-Designer", # src/3rdparty/{include,src}/md5.*
    "blessing", # src/3rdparty/{include,src}/sqlite/sqlite3*
  ]
  revision 2
  head "https://github.com/clangen/musikcube.git", branch: "master"

  stable do
    url "https://github.com/clangen/musikcube/archive/refs/tags/3.0.4.tar.gz"
    sha256 "25bb95b8705d8c79bde447e7c7019372eea7eaed9d0268510278e7fcdb1378a5"

    # Backport support for newer asio. Using resource to deal with submodule
    resource "asio.patch" do
      url "https://github.com/clangen/musikcube/commit/a5a8a4ba6e21e09185ce10b5ecb48d6bb30f3d07.patch?full_index=1"
      sha256 "58e4215a6319b625a5c11990732ebabb2622e1dc7a91d5ef48ec791db415b704"

      # Remove submodule modification as `patch` can't handle this
      patch :DATA
    end

    # Backport support for FFmpeg 8.0
    patch do
      url "https://github.com/clangen/musikcube/commit/a0433606af616b6d1146d10c964195dd81d244c8.patch?full_index=1"
      sha256 "ba1f480663d28e0d25f84c11e9b60a03600f37976794fd58349e038ac85e2229"
    end
    patch do
      url "https://github.com/clangen/musikcube/commit/1a5887f6dcd8f0c3ed7ddef400a7dc1114721459.patch?full_index=1"
      sha256 "a04ce7b24631d371ea77373026d617661cfe091b94cd356e349d77561b8bda84"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "26a255dcf4514ba323fd8432e0707d41a78957663cd9dae29d9721643ff4ce6e"
    sha256 cellar: :any,                 arm64_sequoia: "9db1d89d137c22936f096852017272d7ba739ccda6b75771e983be8b9392ab7a"
    sha256 cellar: :any,                 arm64_sonoma:  "69618b6cb44fed6f13814c8d7ef559dbd4f14bfd268952d58554a85d6baa315c"
    sha256 cellar: :any,                 arm64_ventura: "a6f22f38cc129c056f1aecec46a00d6aac5a392f4707826c67872bccabf8fc12"
    sha256 cellar: :any,                 sonoma:        "ebb47ab602bff2a08b8f610f862cb81df7252c6b3e1d66bf7a374b06edeaa8f6"
    sha256 cellar: :any,                 ventura:       "1a4c4aef8caa5bfc661831b17b1bf84d6695dd4f686c48ef4b6bcd629fa92589"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15eeed9a2b54c2822d34a1f951ccc7f0a06da22c4c6731f836ab8105d3a6609e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "186e8821eb5685fe54c2419c8cdcbf018460b3e60fe434ea6b53392b78e081bb"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "ffmpeg"
  depends_on "game-music-emu"
  depends_on "lame"
  depends_on "libev"
  depends_on "libmicrohttpd"
  depends_on "libopenmpt"
  depends_on "ncurses"
  depends_on "openssl@3"
  depends_on "portaudio"
  depends_on "taglib"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gnutls"
    depends_on "mpg123"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "pulseaudio"
    depends_on "systemd"
  end

  def install
    if build.stable?
      resource("asio.patch").stage { buildpath.install Dir["*"].first => "asio.patch" }
      Patch.create(:p1, File.read("asio.patch")).apply
    end

    # Pretend to be Nix to dynamically link ncurses on macOS.
    ENV["NIX_CC"] = ENV.cc

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["MUSIKCUBED_LOCKFILE_OVERRIDE"] = lockfile = testpath/"musikcubed.lock"
    system bin/"musikcubed", "--start"
    sleep 10
    assert_path_exists lockfile
    tries = 0
    begin
      system bin/"musikcubed", "--stop"
    rescue BuildError
      # Linux CI seems to take some more time to stop
      retry if OS.linux? && (tries += 1) < 3
      raise
    end
  end
end

__END__
--- a/a5a8a4ba6e21e09185ce10b5ecb48d6bb30f3d07.patch
+++ b/a5a8a4ba6e21e09185ce10b5ecb48d6bb30f3d07.patch
@@ -29,13 +29,6 @@ Subject: [PATCH] Update to asio 1.36.0
  create mode 100644 src/3rdparty/include/websocketpp/transport/debug/connection.hpp
  create mode 100644 src/3rdparty/include/websocketpp/transport/debug/endpoint.hpp
 
-diff --git a/src/3rdparty/asio b/src/3rdparty/asio
-index f693a3eb7fe72a5f19b975289afc4f437d373d9c..231cb29bab30f82712fcd54faaea42424cc6e710 160000
---- a/src/3rdparty/asio
-+++ b/src/3rdparty/asio
-@@ -1 +1 @@
--Subproject commit f693a3eb7fe72a5f19b975289afc4f437d373d9c
-+Subproject commit 231cb29bab30f82712fcd54faaea42424cc6e710
 diff --git a/src/3rdparty/include/websocketpp/roles/server_endpoint.hpp b/src/3rdparty/include/websocketpp/roles/server_endpoint.hpp
 index 9cc652f75ce1c31c597341e5ec2ad47ce17a40be..1967a4733e1a77045f8b5bce6cd0fad335c7a4a5 100644
 --- a/src/3rdparty/include/websocketpp/roles/server_endpoint.hpp
