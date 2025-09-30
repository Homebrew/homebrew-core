class Libhttpserver < Formula
  desc "C++ library of embedded Rest HTTP server"
  homepage "https://github.com/etr/libhttpserver"
  url "https://github.com/etr/libhttpserver/archive/refs/tags/0.19.0.tar.gz"
  sha256 "b108769ed68d72c58961c517ab16c3a64e4efdc4c45687723bb45bb9e04c5193"
  license "LGPL-2.1-or-later"
  head "https://github.com/etr/libhttpserver.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "3c6d43ba60b58af6cbb736fcef51bc8378c8616ba1bc9be95699d19f588cfa4a"
    sha256 cellar: :any,                 arm64_sequoia:  "a52ab6c0ede296608a7aa71640485e6295b72ae13cfdbb14cbd91c032d9c0af7"
    sha256 cellar: :any,                 arm64_sonoma:   "8656daf385c457a28484c8bff0d6271a5271980ab97899b249c1890274617fb7"
    sha256 cellar: :any,                 arm64_ventura:  "b11af50845ce2a87984d6240d3d7db441be82f84fde6fc6447866cc0dd5e6236"
    sha256 cellar: :any,                 arm64_monterey: "ce9d31e81bfbc06990ae1b57b295278e341d5917e157688d999f48c102ec4fba"
    sha256 cellar: :any,                 arm64_big_sur:  "48dae7ff73d5edc565cf97ce6c3f1f9a441e333d3ba0021602add200c3e316f4"
    sha256 cellar: :any,                 sonoma:         "f7bd8a4823e25a2d328750d6e900cba1addc794c168bff61c89d49c2df2383fd"
    sha256 cellar: :any,                 ventura:        "4bfcce305d2fb4ae798d9b5a0ce54bf7bfc3a6a3636f7a500dee69ecd3161e32"
    sha256 cellar: :any,                 monterey:       "2eb240316761233c156364b47f7e5a1d0a280baaad49530f5e27ae7f19969db5"
    sha256 cellar: :any,                 big_sur:        "f79987ebd2cc129a3ff7a6ee5f3e4ba62cd3926a5fa66554b6b6c32a70661e20"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f4983970f413cd3b10229548e9ead19177cd534aa1aefac1903d4e9a4b7b4d1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d0e06fdd786113649df4bb86729c6fd53c94b77cb6985a0aa43831cdbbb43bc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libmicrohttpd"

  uses_from_macos "curl" => :test

  def install
    system "./bootstrap"
    mkdir "build" do
      system "../configure", "--disable-silent-rules", *std_configure_args
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
      "-std=c++17", "-o", "minimal_hello_world", "-L#{lib}", "-lhttpserver", "-lcurl"

    spawn "./minimal_hello_world"
    sleep 3 # grace time for server start

    assert_match "Hello, World!", shell_output("curl http://127.0.0.1:#{port}/hello")
  end
end
