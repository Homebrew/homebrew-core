class Libhttpserver < Formula
  desc "C++ library of embedded Rest HTTP server"
  homepage "https://github.com/etr/libhttpserver"
  url "https://github.com/etr/libhttpserver/archive/0.18.2.tar.gz"
  sha256 "1dfe548ac2add77fcb6c05bd00222c55650ffd02b209f4e3f133a6e3eb29c89d"
  license "LGPL-2.1-or-later"
  head "https://github.com/etr/libhttpserver.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4006a6d0b9bb22cb3f326988fc0a8f5bc4d7a5256206a8434a6449a23e74b169"
    sha256 cellar: :any,                 arm64_monterey: "a7373b51c70174b698e57eb9543662b342a9c277d87dc096fd00359e82e83c85"
    sha256 cellar: :any,                 arm64_big_sur:  "fdec5ac92f5b5d22d3b8a335938b23b9e20605b475dc3c1b2e9ced920b0b33e0"
    sha256 cellar: :any,                 ventura:        "eb4d4ce20b63ca07f91e98b772bd585cf243682f36690ec6087932fa779d4e2a"
    sha256 cellar: :any,                 monterey:       "ddece3c44cd79a12868efccbd72be70eef25f45a91aff5998ef3e644a215cf8d"
    sha256 cellar: :any,                 big_sur:        "17103a950045c06e959eb1d034f0a1cee89531084940f8844f1dcd4331beb4aa"
    sha256 cellar: :any,                 catalina:       "6684db18245d033c86c7887feca8dba18cd3e07c5dbd9a9379c4107331f68a14"
    sha256 cellar: :any,                 mojave:         "755c274617ee811c4fda5ee110ba46dd3f171cc4bac67925ca159cfefcdb0b99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52afb93c01b3fd69b8f589e696c7ce8d4dd35d0c04af4c1467c441da96ca3dac"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libmicrohttpd"

  uses_from_macos "curl" => :test

  def install
    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
    ]

    system "./bootstrap"
    mkdir "build" do
      system "../configure", *args
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    port = free_port

    cp pkgshare/"examples/minimal_hello_world.cpp", testpath
    inreplace "minimal_hello_world.cpp", "create_webserver(8080)",
                                         "create_webserver(#{port})"

    system ENV.cxx, "minimal_hello_world.cpp",
      "-std=c++11", "-o", "minimal_hello_world", "-L#{lib}", "-lhttpserver", "-lcurl"

    fork { exec "./minimal_hello_world" }
    sleep 3 # grace time for server start

    assert_match "Hello, World!", shell_output("curl http://127.0.0.1:#{port}/hello")
  end
end
