class Olsrd < Formula
  desc "Implementation of the optimized link state routing protocol"
  homepage "https://github.com/OLSR/olsrd"
  url "https://github.com/OLSR/olsrd/archive/refs/tags/v0.9.8.tar.gz"
  sha256 "ee9e524224e5d5304dcf61f1dc5485c569da09d382934ff85b233be3e24821a3"
  license "BSD-3-Clause"
  revision 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1b1dd66b69be130d7b2114b401afac090a19e908169401ae0ec784c17690569"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3180890960307db6dc8d4cc7244f2da2772ec65bcba356698b3d6223feb6d6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3aab48c75a5a1b850c781b5baac23b0b2a5b576b10da49b87734746051d3083"
    sha256 cellar: :any_skip_relocation, sonoma:        "939cab603b98b8a89d3fc778b9c5dc7c4bebec64f731221a182442225ec6bf71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "331929ce9da8857820aca9705abadb8681a883346e59031e2f43721d8dac0e70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2a2c0d6260662fcf37251ef13bb25010103ebf8c4fd57f2268ca2640f850313"
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
