class Orbit < Formula
  desc "CORBA 2.4-compliant object request broker (ORB)"
  homepage "https://web.archive.org/web/20191222075841/projects-old.gnome.org/ORBit2/"
  url "https://download.gnome.org/sources/ORBit2/2.14/ORBit2-2.14.19.tar.bz2"
  sha256 "55c900a905482992730f575f3eef34d50bda717c197c97c08fa5a6eafd857550"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-only"]
  revision 1
  head "https://gitlab.gnome.org/Archive/orbit2.git", branch: "master"

  bottle do
    rebuild 3
    sha256 arm64_monterey: "19c4db555e259ad9d2c820e95ccea5f15adab1887083021f7507578ea961c5e8"
    sha256 arm64_big_sur:  "42435b23e00c8227cd80af182e39c4f24ea2bd6e50b01c0df0cd171a92ba4c02"
    sha256 monterey:       "564ab69f0155ea40bd63118434548799463a6817f57eb3296bf553100070becd"
    sha256 big_sur:        "d39f55257c7d7eff2ecb9bb03c596a23d53abf2c081b87bf06f1b93415dda0b4"
    sha256 catalina:       "3108db04a65e53b067b29f700b1360e90badde53e891555f341fabe7c5dd5fe4"
    sha256 mojave:         "638d7bc192d39014137dfe3508e935b0b129b78e1f6971c1342e8ed1a52b2900"
    sha256 x86_64_linux:   "9403e552d8faa81a930060351bd0e757dd279f51c7a05a8d35c08de560a27c2f"
  end

  # GNOME 2.19 deprecated Orbit2 in 2007; now even their webpage for it is gone as of 2020
  deprecate! date: "2020-12-25", because: :deprecated_upstream

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libidl"

  # per MacPorts, re-enable use of deprecated glib functions
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/6b7eaf2b/orbit/patch-linc2-src-Makefile.in.diff"
    sha256 "572771ea59f841d74ac361d51f487cc3bcb2d75dacc9c20a8bd6cbbaeae8f856"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/6b7eaf2b/orbit/patch-configure.diff"
    sha256 "34d068df8fc9482cf70b291032de911f0e75a30994562d4cf56b0cc2a8e28e42"
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/orbit2-config --prefix --version")
  end
end
