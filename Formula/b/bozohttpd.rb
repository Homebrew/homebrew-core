class Bozohttpd < Formula
  desc "Small and secure http version 1.1 server"
  homepage "https://pkgsrc.se/www/bozohttpd"
  url "https://cdn.netbsd.org/pub/pkgsrc/distfiles/LOCAL_PORTS/bozohttpd-20240126.tar.bz2"
  sha256 "576267bc5681c52b650294c3f2a85b8c8d8c239e75e71aaba7973771f852b56d"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url "https://cdn.netbsd.org/pub/pkgsrc/distfiles/"
    regex(/href=.*?bozohttpd[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "08add554b4f9e6039d3ff57f273abb1ed60e8d691c5029eb4d24a693b28f1182"
    sha256 cellar: :any,                 arm64_sequoia: "647389ce4b7541386a18139d7aaf53836a970a740cbe975a559448d9d016ad3d"
    sha256 cellar: :any,                 arm64_sonoma:  "6644d9378c0d0f1b8ae2c895c211dfb4424d35a67fb0f413c1f1ac1c34615d36"
    sha256 cellar: :any,                 sonoma:        "18b2b7b64fc29b2dfb7bf187e3548b49aa4600379f3e2d3e3391955978b85bc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e4732ae790f55b727b93df73c83712490db2eed6cdd7c2f6c17c69544538409"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8b06ea44de6ededf75e8233f192670cfc33163d80487719b505cd185ceb228a"
  end

  depends_on "openssl@4"

  def install
    system "make", "-f", "Makefile.boot", "CC=#{ENV.cc}"
    bin.install "bozohttpd"
  end

  test do
    port = free_port

    expected_output = "Hello from bozotic httpd!"
    (testpath/"index.html").write expected_output

    spawn bin/"bozohttpd", "-b", "-f", "-I", port.to_s, testpath
    assert_match expected_output, shell_output("curl --silent --retry 5 --retry-connrefused 127.0.0.1:#{port}")
  end
end
