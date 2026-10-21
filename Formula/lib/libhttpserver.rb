class Libhttpserver < Formula
  desc "C++ library of embedded Rest HTTP server"
  homepage "https://github.com/etr/libhttpserver"
  url "https://github.com/etr/libhttpserver/releases/download/2.0.1/libhttpserver-2.0.1.tar.gz"
  sha256 "767716a689b5078a9e6ad4e6dc5c2708a50c79f195fce599dd80e35566c8f64a"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ff0afd3a1a8230f6b88866bd3479bbc0a73b3c9ec163d156e684be494fee5020"
    sha256 cellar: :any, arm64_tahoe:       "15bbcf2ce98a99c639113f41fbe376f3d57a81f56108ecf4f07192f4d99fa36a"
    sha256 cellar: :any, arm64_sequoia:     "12458ccbe10f0e689d04cc02ecb01215b29ecceabd790cc60e9812582240369b"
    sha256 cellar: :any, arm64_linux:       "96812298240d58906fbdb349ca7a2b0cfe97e125572f5505c81dfa959567ea17"
    sha256 cellar: :any, x86_64_linux:      "b7e87e600cde95eb4535ba505bedbabfd562a3592679fd5a0f4dba4f2b99efcc"
  end

  head do
    url "https://github.com/etr/libhttpserver.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "libmicrohttpd"

  uses_from_macos "curl" => :test

  allow_network_access! :test

  def install
    system "./bootstrap" if build.head?
    mkdir "build" do
      system "../configure", "--disable-silent-rules", *std_configure_args
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    port = free_port

    cp pkgshare/"examples/hello_world.cpp", testpath
    inreplace "hello_world.cpp", "create_webserver(8080)", "create_webserver(#{port})"

    system ENV.cxx, "hello_world.cpp",
      "-std=c++20", "-o", "hello_world", "-L#{lib}", "-lhttpserver", "-lcurl"

    pid = spawn "./hello_world"

    assert_match "Hello, World!",
                 shell_output("curl --silent --show-error --retry 5 --retry-connrefused http://127.0.0.1:#{port}/hello")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
