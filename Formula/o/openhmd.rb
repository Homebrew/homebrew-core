class Openhmd < Formula
  desc "Free and open source API and drivers for immersive technology"
  homepage "http://openhmd.net"
  url "https://github.com/OpenHMD/OpenHMD/archive/refs/tags/0.3.0.tar.gz"
  sha256 "ec5c97ab456046a8aef3cde6d59e474603af398f1d064a66e364fe3c0b26a0fa"
  license "BSL-1.0"
  head "https://github.com/OpenHMD/OpenHMD.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "67a5d2f64c142bf6a00d24f1b1e1af1051db91de9af1487980702af8f9d49759"
    sha256 cellar: :any,                 arm64_sequoia:  "743ff7cdd099472c22867b6883dbebb8731898e770c6c9a9c16e42a99de5b10a"
    sha256 cellar: :any,                 arm64_sonoma:   "f234246a30572beddda70313054bf10e58a96ee842bbeded6e1d1017febc0c02"
    sha256 cellar: :any,                 arm64_ventura:  "6b2e1d6170301fe50af6c5b9bee467a9c18f346cf2ff630338fd410bfbf992ff"
    sha256 cellar: :any,                 arm64_monterey: "536ae72b1f5e8dea9417cd010b787e4dfa94ece6c8fa3da651186f6e2ceb2d8c"
    sha256 cellar: :any,                 arm64_big_sur:  "19e9b946bbefe306dc41aa803e5cb48aec3ab62bf334b8975e660f4a3644c0c7"
    sha256 cellar: :any,                 sonoma:         "2ecd76892befd509fe79dbf294e309a7ff5ae1333abef885dc984b5a4ef0a486"
    sha256 cellar: :any,                 ventura:        "3f960a5ab5e3466341ac6fcf533c317e37183338d770ca5b63f8aec92f48cd1b"
    sha256 cellar: :any,                 monterey:       "5e04fd446926530d2a5349d07d0354c4943c75b73220319ec38d27db42bb281e"
    sha256 cellar: :any,                 big_sur:        "875f651a4d9b710ce00e899928b2b9dab6f26cbfee670135566821e524d5337a"
    sha256 cellar: :any,                 catalina:       "351e8d9e6bfa22b63b035c0f9c0c7e37be52b9e4058c50d7b7ac321eca880e5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "73a9068341d342a933ae584e67ce2820ab612e05bd3ba35f9c2127102d9f2794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c07dcb0b3e3848fe49493fef2323a7f143fb70a695e67738355f3c1f30008d44"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "hidapi"

  conflicts_with "cspice", because: "both install `simple` binaries"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    (pkgshare/"tests").install bin/"unittests"
  end

  test do
    system pkgshare/"tests/unittests"
  end
end
