class Nuvie < Formula
  desc "Ultima 6 engine"
  homepage "https://nuvie.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/nuvie/Nuvie/0.5/nuvie-0.5.tgz"
  sha256 "ff026f6d569d006d9fe954f44fdf0c2276dbf129b0fc5c0d4ef8dce01f0fc257"
  license "GPL-2.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "fa2594d6ea248c288f64937010118a7b84c70264c24dae72c5e6059930c9a35d"
    sha256 cellar: :any,                 arm64_sequoia: "75819c942c2151264b9586aff141b43f0c52032fbaf8c0701cb0543dbb293edb"
    sha256 cellar: :any,                 arm64_sonoma:  "139b517e55da813691b4421a2c93bb3189596cd861de948332563717aca30403"
    sha256 cellar: :any,                 sonoma:        "951b540e1014c1606cd98a4d0fd48ada753a1fb81704fbb24d87521444eb8132"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c25afc497b351fc27250785b4140257a175ee68d538130cebed19703b6c33f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef7d6d14dcdf5c273ec268154ab409f33a14d494a087f25ee51289ea0c5a6de6"
  end

  head do
    url "https://github.com/nuvie/nuvie.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "sdl12-compat"

  def install
    # Work around GCC 11 / Clang 17 failure due to higher default C++ standard.
    # We use C++03 standard as C++11 standard needs upstream fix.
    # We append to CXX because CXXFLAGS is also used for C code somehow.
    # Ref: https://github.com/nuvie/nuvie/commit/69fb52d35d5eaffcf3bca56929ab58a99defec3d
    ENV.append "CXX", "-std=c++03" if OS.linux? || DevelopmentTools.clang_build_version >= 1700

    inreplace "./nuvie.cpp" do |s|
      s.gsub! 'datadir", "./data"',
              "datadir\", \"#{lib}/data\""
      s.gsub! 'home + "/Library',
              '"/Library'
      s.gsub! 'config_path.append("/Library/Preferences/Nuvie Preferences");',
              "config_path = \"#{var}/nuvie/nuvie.cfg\";"
      s.gsub! "/Library/Application Support/Nuvie Support/",
              "#{var}/nuvie/game/"
      s.gsub! "/Library/Application Support/Nuvie/",
              "#{var}/nuvie/"
    end

    system "./autogen.sh" if build.head?

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", "--disable-sdltest", *args, *std_configure_args
    system "make"
    bin.install "nuvie"
    pkgshare.install "data"
    (var/"nuvie/game").mkpath
  end

  def caveats
    <<~EOS
      Copy your Ultima 6 game files into the following directory:
        #{var}/nuvie/game/ultima6/
      Save games will be stored in the following directory:
        #{var}/nuvie/savegames/
      Config file will be located at:
        #{var}/nuvie/nuvie.cfg
    EOS
  end

  test do
    pid = fork do
      exec bin/"nuvie"
    end
    sleep 3

    assert_path_exists bin/"nuvie"
    assert_predicate bin/"nuvie", :executable?
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
