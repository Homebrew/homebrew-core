class Olsrd < Formula
  desc "Implementation of the optimized link state routing protocol"
  homepage "https://github.com/OLSR/olsrd"
  url "https://github.com/OLSR/olsrd/archive/refs/tags/v0.9.8.tar.gz"
  sha256 "ee9e524224e5d5304dcf61f1dc5485c569da09d382934ff85b233be3e24821a3"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0aeb303759d085dad7b581e75104d268df5b320c64abe9030b55a10ab6cfbd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b708682b004bbec11078438431bcfe45287081bfad38dc5642e3b66b8917d6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d0390ab383fd753be5a69c7cf979639928716aecbd30cf7125d226c9aec00cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "b455eae0e98b02d306ac032239b28c361031d79ba60d05739da0cad83c01a60e"
    sha256 cellar: :any_skip_relocation, ventura:       "abaac5b8b0b1a3a783e76b8d2e68acb4d51c3c6a4086e5bd78d94f598ea28460"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b20249ebcbba2d3ca74f80ec36e6f412cf0bc7e14d80faff72f3e032b7e07f45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33113cc2b9ddad06caa174c9fc98e49b3aa4bbb01ede5b82945d7d9c597be727"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_macos do
    depends_on "coreutils" => :build # needs GNU cp
  end

  on_linux do
    depends_on "gpsd"

    # patch to support gpsd 3.25, remove when patch avail in the upstream
    patch do
      url "https://github.com/OLSR/olsrd/commit/17d583258969c1d182361e0e168b3cad79ef64e6.patch?full_index=1"
      sha256 "2c7a210a3a504f1df51da3ceb0908d309c447a9a1566d6da244f4ae9e9e3cab1"
    end
  end

  # Apply upstream commit to fix build with bison >= 3.7.1
  patch do
    url "https://github.com/OLSR/olsrd/commit/be461986c6b3180837ad776a852be9ce22da56c0.patch?full_index=1"
    sha256 "6ec65c73a09f124f7e7f904cc6620699713b814eed95cd3bc44a0a3c846d28bd"
  end

  # Apply 3 upstream commits to fix build with gpsd >= 3.20
  patch do
    url "https://github.com/OLSR/olsrd/commit/b2dfb6c27fcf4ddae87b0e99492f4bb8472fa39a.patch?full_index=1"
    sha256 "a49a20a853a1f0f1f65eb251cd2353cdbc89e6bbd574e006723c419f152ecbe3"
  end

  patch do
    url "https://github.com/OLSR/olsrd/commit/79a28cdb4083b66c5d3a5f9c0d70dbdc86c0420c.patch?full_index=1"
    sha256 "6295918ed6affdca40c256c046483752893475f40644ec8c881ae1865139cedf"
  end

  patch do
    url "https://github.com/OLSR/olsrd/commit/665051a845464c0f95edb81432104dac39426f79.patch?full_index=1"
    sha256 "e49ee41d980bc738c0e4682c2eca47e25230742f9bdbd69b8bd9809d2e25d5ab"
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin"
    lib.mkpath
    args = %W[
      DESTDIR=#{prefix}
      USRDIR=#{prefix}
      LIBDIR=#{lib}
      SBINDIR=#{sbin}
      SHAREDIR=#{pkgshare}
      MANDIR=#{man}
      ETCDIR=#{etc}
    ]
    system "make", "build_all", *args
    system "make", "install_all", *args
  end

  test do
    assert_match version.to_s, pipe_output("#{sbin}/olsrd")
  end
end
