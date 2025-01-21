class Olsrd < Formula
  desc "Implementation of the optimized link state routing protocol"
  homepage "https://github.com/OLSR/olsrd"
  url "https://github.com/OLSR/olsrd/archive/refs/tags/v0.9.8.tar.gz"
  sha256 "ee9e524224e5d5304dcf61f1dc5485c569da09d382934ff85b233be3e24821a3"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "874cb9fc08951755b92d6f4310d46d3204bf67785ae95d96d07ef754f22fbb83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6c4e30770465a800d9d40fbf7098db2cbcffb15c511fdff67f9e6efda615122"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5855775631424ec0e2b51d6f3a08a83e595865c4f3090c24756d77a36f2d088b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "595f6879e8ea37977d87ce63927c7e731dde41717b070cec7faa8426e1c43109"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46f59369b499e8dd35c9ae619ce0b893e0324778500a08007ece6c1329d19cdd"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3a78a11535c74218df2662750962b39aab888ecd39e5c57571befaf0a608b5d"
    sha256 cellar: :any_skip_relocation, ventura:        "b8950dc67c22e934018c5898834001cfa8345f2828acee9fea14ce7b7131dc4f"
    sha256 cellar: :any_skip_relocation, monterey:       "a995c9cac2e2cb70a3235322c39fb259e634c932b45f0a64499c347003a03489"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e94afd5a8ed394b3fae056b10af1575c6a4383500978c7afe0b1ee375c8b4bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2acf80ab45800922a52d9df98d466e657ff8b7d2dedb05cd9cd1c18f09457388"
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
