class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio/"
  url "https://downloads.sourceforge.net/project/asio/asio/1.38.2%20%28Stable%29/asio-1.38.2.tar.bz2"
  sha256 "c04e0e66ac29741faad763a56f3c50196421d4b968009fc237c53314769bf8ad"
  license "BSL-1.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?Stable.*?/asio[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "11ef27f86eddd6a508404e15a51fe2b18d87c25bbc93660df71c04fc210fe0a5"
  end

  head do
    url "https://github.com/chriskohlhoff/asio.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  allow_network_access! :test

  def install
    if build.head?
      cd "asio"
      system "./autogen.sh"
    end

    # NOTE: OpenSSL is only used at build time for examples and tests.
    # Dependents can still use optional SSL feature with any supported SSL
    # (e.g. OpenSSL/WolfSSL) without needing to force a dependency.
    system "./configure", "--disable-silent-rules",
                          "--without-boost",
                          *std_configure_args
    system "make", "install"
    (pkgshare/"example_http_server").install Dir["src/examples/cpp11/http/server/*.{cpp,hpp}"]
  end

  test do
    cp_r (pkgshare/"example_http_server").children, testpath
    system ENV.cxx, "-std=c++11", "-o", "http_server", *Dir["*.cpp"]

    port = free_port
    pid = spawn "./http_server", "127.0.0.1", port.to_s, "."
    begin
      sleep 5
      assert_match "404 Not Found", shell_output("curl http://127.0.0.1:#{port}")
    ensure
      Process.kill 9, pid
    end
  end
end
