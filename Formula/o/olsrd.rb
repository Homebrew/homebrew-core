class Olsrd < Formula
  desc "Implementation of the optimized link state routing protocol"
  homepage "https://github.com/OLSR/olsrd"
  url "https://github.com/OLSR/olsrd/archive/refs/tags/v0.9.8.tar.gz"
  sha256 "ee9e524224e5d5304dcf61f1dc5485c569da09d382934ff85b233be3e24821a3"
  license "BSD-3-Clause"
  revision 4

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "f3e61618d5719b3be42bc2592a5e96f178a1d9fee254fdb202496703de34a7e4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "251cf96cab79bc721c39a34108f66d64551414fa7e29b1507659f8ad4b790426"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "24353431ac1cd81eebf2d8279efcce49ec4c4c9a3c57735fad457c7e7963a10c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ad0ed6461d43a57ebf0bb24ff2bbfc553e3afea0b979ea209f3aa023ff517f10"
    sha256 cellar: :any,                 arm64_linux:       "e0d08d6ae889658efdeb70861c5b970f34cd1cd972bcebd43fec7d4e578a7f93"
    sha256 cellar: :any,                 x86_64_linux:      "f6642c210147970c4c713d2621f8144add08790a195e3f72d671b9234c3779f6"
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
      type :backport
    end
  end

  # Apply upstream commit to fix build with bison >= 3.7.1
  patch do
    url "https://github.com/OLSR/olsrd/commit/be461986c6b3180837ad776a852be9ce22da56c0.patch?full_index=1"
    sha256 "6ec65c73a09f124f7e7f904cc6620699713b814eed95cd3bc44a0a3c846d28bd"
    type :backport
  end

  # Apply 3 upstream commits to fix build with gpsd >= 3.20
  patch do
    url "https://github.com/OLSR/olsrd/commit/b2dfb6c27fcf4ddae87b0e99492f4bb8472fa39a.patch?full_index=1"
    sha256 "a49a20a853a1f0f1f65eb251cd2353cdbc89e6bbd574e006723c419f152ecbe3"
    type :backport
  end

  patch do
    url "https://github.com/OLSR/olsrd/commit/79a28cdb4083b66c5d3a5f9c0d70dbdc86c0420c.patch?full_index=1"
    sha256 "6295918ed6affdca40c256c046483752893475f40644ec8c881ae1865139cedf"
    type :backport
  end

  patch do
    url "https://github.com/OLSR/olsrd/commit/665051a845464c0f95edb81432104dac39426f79.patch?full_index=1"
    sha256 "e49ee41d980bc738c0e4682c2eca47e25230742f9bdbd69b8bd9809d2e25d5ab"
    type :backport
  end

  def install
    ENV.prepend_path "PATH", formula_opt_libexec("coreutils")/"gnubin"
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
