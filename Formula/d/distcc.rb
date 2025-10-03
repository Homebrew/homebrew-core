class Distcc < Formula
  include Language::Python::Virtualenv

  desc "Distributed compiler client and server"
  homepage "https://github.com/distcc/distcc/"
  url "https://github.com/distcc/distcc/releases/download/v3.4/distcc-3.4.tar.gz"
  sha256 "2b99edda9dad9dbf283933a02eace6de7423fe5650daa4a728c950e5cd37bd7d"
  license "GPL-2.0-or-later"
  revision 3
  head "https://github.com/distcc/distcc.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "32c7926148b23328d8ceae1e7093685846864d97a1d250f587054d83bf07a877"
    sha256 arm64_sequoia: "b98395e66b59e15e749f8653a24a7cdb21ed924ab38789987937b424087db48c"
    sha256 arm64_sonoma:  "3f7592cb46c1103e012aa5321bc042a422cf4feff63f741df469ac0b360048dd"
    sha256 arm64_ventura: "4e2d0d3d71ff226b128e3449b7ef1117dd6f27c46345fc29a293ae246f562dd4"
    sha256 sonoma:        "80254e2dd3cb658907364565ee40c9f60a8aa303cbc9bcc20cf7e7a8c6024a94"
    sha256 ventura:       "50459c98419e4b2d87f529ae4a058f90f011836cd157af010f81137e9468e531"
    sha256 arm64_linux:   "938461a356c88827ebb319494279a8a41959be010e7102adbfe17e79f6da9b61"
    sha256 x86_64_linux:  "92bb7674804a00828013b7a43534c3875624168e13934e3b099afcc8b50698a8"
  end

  depends_on "python@3.13"

  resource "libiberty" do
    url "https://ftp.debian.org/debian/pool/main/libi/libiberty/libiberty_20250315.orig.tar.xz"
    sha256 "5b510b5e0918dcb00a748900103365a00411855f202089ff81dc5ef99d8beeaa"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  # Python 3.10+ compatibility
  patch do
    url "https://github.com/distcc/distcc/commit/83e030a852daf1d4d8c906e46f86375d421b781e.patch?full_index=1"
    sha256 "d65097b7c13191e18699d3a9c7c9df5566bba100f8da84088aa4e49acf46b6a7"
  end

  # Switch from distutils to setuptools
  patch do
    url "https://github.com/distcc/distcc/commit/76873f8858bf5f32bda170fcdc1dfebb69de0e4b.patch?full_index=1"
    sha256 "611910551841854755b06d2cac1dc204f7aaf8c495a5efda83ae4a1ef477d588"
  end

  def install
    ENV["PYTHON"] = python3 = which("python3.13")
    site_packages = prefix/Language::Python.site_packages(python3)

    build_venv = virtualenv_create(buildpath/"venv", python3)
    build_venv.pip_install resource("setuptools")
    ENV.prepend_create_path "PYTHONPATH", build_venv.site_packages

    # While libiberty recommends that packages vendor libiberty into their own source,
    # distcc wants to have a package manager-installed version.
    # Rather than make a package for a floating package like this, let's just
    # make it a resource.
    resource("libiberty").stage do
      system "./libiberty/configure", "--prefix=#{buildpath}", "--enable-install-libiberty"
      system "make", "install"
    end
    ENV.append "CPPFLAGS", "-I#{buildpath}/include"
    ENV.append "LDFLAGS", "-L#{buildpath}/lib"

    # Work around Homebrew's "prefix scheme" patch which causes non-pip installs
    # to incorrectly try to write into HOMEBREW_PREFIX/lib since Python 3.10.
    inreplace "Makefile.in", '--root="$$DESTDIR"', "--install-lib='#{site_packages}'"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  service do
    run [opt_bin/"distccd", "--allow=192.168.0.1/24"]
    keep_alive true
    working_dir opt_prefix
  end

  test do
    system bin/"distcc", "--version"

    (testpath/"Makefile").write <<~MAKE
      default:
      	@echo Homebrew
    MAKE
    assert_match "distcc hosts list does not contain any hosts", shell_output("#{bin}/pump make 2>&1", 1)

    # `pump make` timeout on linux runner and is not reproducible, so only run this test for macOS runners
    return unless OS.mac?

    ENV["DISTCC_POTENTIAL_HOSTS"] = "localhost"
    assert_match "Homebrew\n", shell_output("#{bin}/pump make")
  end
end
