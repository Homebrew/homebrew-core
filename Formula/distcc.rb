class Distcc < Formula
  desc "Distributed compiler client and server"
  homepage "https://github.com/distcc/distcc/"
  url "https://github.com/distcc/distcc/releases/download/v3.4/distcc-3.4.tar.gz"
  sha256 "2b99edda9dad9dbf283933a02eace6de7423fe5650daa4a728c950e5cd37bd7d"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/distcc/distcc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "8b2fbc5cf4cb8d9476da2625a957915944649cae75fb3108b0bc96a4a4566dc2"
    sha256 arm64_monterey: "c81d6a2c9a61ef14dce35ace5f8c6178818fc31df0737340e7a132f00f0f65a4"
    sha256 arm64_big_sur:  "65af444c16f90e930c9bfb1bbc409dc3bb448de3074fd66d6c4e838286a97de0"
    sha256 ventura:        "df8c4c8014e106395f5bd5c442b3e001d74ebc4b5f974501f62398e1bfe7c9d7"
    sha256 monterey:       "8f3321e99183c5839f84d1a6c49e64befa3d4c028a7e245b1943ac91c36d513e"
    sha256 big_sur:        "beb61452ff642e970da5d457f55d7bee4667c095a531dd2f34424afebf6dca00"
    sha256 x86_64_linux:   "de6c0c43468eff787ff1fce4f00c476df27327f798e1c483c6cd41e239fba684"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.11"

  resource "libiberty" do
    url "https://ftp.debian.org/debian/pool/main/libi/libiberty/libiberty_20210106.orig.tar.xz"
    sha256 "9df153d69914c0f5a9145e0abbb248e72feebab6777c712a30f1c3b8c19047d4"
  end

  # Python 3.10+ compatibility
  patch do
    url "https://github.com/distcc/distcc/commit/83e030a852daf1d4d8c906e46f86375d421b781e.patch?full_index=1"
    sha256 "d65097b7c13191e18699d3a9c7c9df5566bba100f8da84088aa4e49acf46b6a7"
  end

  def install
    ENV["PYTHON"] = python3 = which("python3.11")
    site_packages = prefix/Language::Python.site_packages(python3)

    # While libiberty recommends that packages vendor libiberty into their own source,
    # distcc wants to have a package manager-installed version.
    # Rather than make a package for a floating package like this, let's just
    # make it a resource.
    buildpath.install resource("libiberty")
    cd "libiberty" do
      system "./configure"
      system "make"
    end
    ENV.append "LDFLAGS", "-L#{buildpath}/libiberty"
    ENV.append_to_cflags "-I#{buildpath}/include"

    # Make sure python stuff is put into the Cellar.
    # --root triggers a bug and installs into HOMEBREW_PREFIX/lib/python2.7/site-packages instead of the Cellar.
    inreplace "Makefile.in", '--root="$$DESTDIR"', "--install-lib=\"#{site_packages}\""
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  service do
    run [opt_bin/"distccd", "--allow=192.168.0.1/24"]
    keep_alive true
    working_dir opt_prefix
  end

  test do
    system "#{bin}/distcc", "--version"

    (testpath/"Makefile").write <<~EOS
      default:
      \t@echo Homebrew
    EOS
    assert_match "distcc hosts list does not contain any hosts", shell_output("#{bin}/pump make 2>&1", 1)

    # `pump make` timeout on linux runner and is not reproducible, so only run this test for macOS runners
    return unless OS.mac?

    ENV["DISTCC_POTENTIAL_HOSTS"] = "localhost"
    assert_match "Homebrew\n", shell_output("#{bin}/pump make")
  end
end
