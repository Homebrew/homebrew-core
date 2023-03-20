class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://downloads.es.net/pub/iperf/iperf-3.13.tar.gz"
  sha256 "bee427aeb13d6a2ee22073f23261f63712d82befaa83ac8cb4db5da4c2bdc865"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1854ac074c5197baded5ee4264abeea79b925b5ca5a814c8d06a4f6419ca5b6f"
    sha256 cellar: :any,                 arm64_monterey: "69ce7edd9c141540e3de9bb8ddcd244f21c5cec1df2a83bdc62a5caa9cbdd3b8"
    sha256 cellar: :any,                 arm64_big_sur:  "4f2fe4de61bb54ab37a103c2268cf5b391e2ed6853e49be36db752b3f01a05a9"
    sha256 cellar: :any,                 ventura:        "c74fe2977234cce9d735254893918328c25726594a8c1a4a7f1396881055c91b"
    sha256 cellar: :any,                 monterey:       "b38e25aa1116f8f8b7ac917c96d3489db2f85066f975e98f3b81a3051c133e0f"
    sha256 cellar: :any,                 big_sur:        "e45b6b3c9a42681d382f4fd4a273a02d8a49f93dfc0c3ac94299cd92d883d366"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da08f6777e50e8b30f2a07d5626debddffc26ee4da90632a86ea2bf5012d782d"
  end

  head do
    url "https://github.com/esnet/iperf.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@3"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-profiling",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}"
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
