class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.6/libtorrent-rasterbar-2.0.6.tar.gz"
  sha256 "438e29272ff41ccc68ec7530f1b98d639f6d01ec8bf680766336ae202a065722"
  license "BSD-3-Clause"
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e687f7de7e75f8dd0a73eafa0ecd25a249303e5316288f89f29be1c430543240"
    sha256 cellar: :any,                 arm64_big_sur:  "5618737ac044c0e3900c80f316b07b2e173f4bc50dafb1500ec657a16a60aa1e"
    sha256 cellar: :any,                 monterey:       "7d08ec9f0ce9f91960199d7ac334a570820315e9da120fe963f870a366e04467"
    sha256 cellar: :any,                 big_sur:        "ef6dbda9a22b814e1156d9a985e58b8b243359867c5240ef53f0a558685070cb"
    sha256 cellar: :any,                 catalina:       "2fbb49d6e2c3ab893899a0c2461c3f7f52741dbc53fa12a1dea630608bf426b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "280a15b7b937c6d8d7399c9c47e5744e02ead57631f0015b25938461cb5f0756"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  conflicts_with "libtorrent-rakshasa", because: "they both use the same libname"

  def install
    args = %w[
      -DCMAKE_CXX_STANDARD=14
      -Dencryption=ON
      -Dpython-bindings=ON
      -Dpython-egg-info=ON
      -DCMAKE_INSTALL_RPATH=#{lib}
    ]
    args += std_cmake_args

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    libexec.install "examples"
  end

  test do
    args = [
      "-I#{Formula["boost"].include}/boost",
      "-L#{Formula["boost"].lib}",
      "-I#{include}",
      "-L#{lib}",
      "-lpthread",
      "-lboost_system",
      "-ltorrent-rasterbar",
    ]

    if OS.mac?
      args += [
        "-framework",
        "SystemConfiguration",
        "-framework",
        "CoreFoundation",
      ]
    end

    system ENV.cxx, libexec/"examples/make_torrent.cpp",
                    "-std=c++14", *args, "-o", "test"
    system "./test", test_fixtures("test.mp3"), "-o", "test.torrent"
    assert_predicate testpath/"test.torrent", :exist?
  end
end
