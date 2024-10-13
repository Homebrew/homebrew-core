class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://downloads.es.net/pub/iperf/iperf-3.17.1.tar.gz"
  sha256 "84404ca8431b595e86c473d8f23d8bb102810001f15feaf610effd3b318788aa"
  license "BSD-3-Clause"

  livecheck do
    url "https://downloads.es.net/pub/iperf/"
    regex(/href=.*?iperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b29ee5f4dd16259bdb26e20cf6a0aefd2d428c586381889d744a92c1974364db"
    sha256 cellar: :any,                 arm64_sonoma:   "e6ddc4a850e6ad07369f041658596e2dab53376658cde9a3571bd51e5c928648"
    sha256 cellar: :any,                 arm64_ventura:  "b0485135b0e0e5c04d2c4b23f81d0983d59f49ecbad9062867d999aa82aa9e23"
    sha256 cellar: :any,                 arm64_monterey: "b7f4bbfe3fd4e06159c964d62994850d5f7b26ae102b0f73cceed90081e3da9b"
    sha256 cellar: :any,                 sonoma:         "d71fc999cb135190fb2f9f8ee330740e95b7f6219403ff27db00e05e6d813c31"
    sha256 cellar: :any,                 ventura:        "7c72d83acb66109e5df009014c8dcf4a81563abde205b287eeb7fd12e5d0fa9c"
    sha256 cellar: :any,                 monterey:       "c331b70baac73a243bc9458855fba5155f269135be16de5186bd7c87905a21d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efb515ecc2c8a9d1eff2a24076f5f9ea3af3e435d60ebce9e95b9f086b5904b7"
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
