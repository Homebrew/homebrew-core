class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.10.1.tar.gz"
  sha256 "6a4bb4d5c124b3fa64dfbda469ab16857ad6565310bcaa3dd8cd32f96c2fc473"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "502bc663fcc6e2e74499818938b006fc2971e1a80378899af1bfd637fa0cad37"
    sha256 cellar: :any,                 arm64_big_sur:  "7acd6b3fedf49e5614f825f928d24b035e93db311c25797d94b8ef880b78afe0"
    sha256 cellar: :any,                 monterey:       "b69f87fbc6557c99e804b2aa57887a1a91d332ac336c435593fcf8ecc3883d2b"
    sha256 cellar: :any,                 big_sur:        "3c7b4daa79c385333b89c08740c477c633d45eba240610f7d43f26a3397555b3"
    sha256 cellar: :any,                 catalina:       "a3d90dab71e047c3c585dc6dfbb63b240b3842e02af8fdaee665bb13b3d71c82"
    sha256 cellar: :any,                 mojave:         "dea44691e2528c58d8f30d5b0b60d2407bb3ba17db5c3d0327fc29442f911847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d078e2b5840746763092d35eede028ccf1b0db86274597ce064c14e5652cae7"
  end

  head do
    url "https://github.com/esnet/iperf.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-profiling",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "clean" # there are pre-compiled files in the tarball
    system "make", "install"
  end

  test do
    server = IO.popen("#{bin}/iperf3 --server")
    sleep 1
    assert_match "Bitrate", pipe_output("#{bin}/iperf3 --client 127.0.0.1 --time 1")
  ensure
    Process.kill("SIGINT", server.pid)
    Process.wait(server.pid)
  end
end
