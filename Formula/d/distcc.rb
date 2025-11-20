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
    rebuild 1
    sha256 arm64_tahoe:   "09fcd33f368d1daff6716752ee32cf50cbb62f7acb0200a0a07bd676d65cd3f2"
    sha256 arm64_sequoia: "232f2d8db68393c3f700e16d29d914e19aa565f2e8a6d2e0e3846c8b317fd931"
    sha256 arm64_sonoma:  "a25d35cebbe97e9bb683c53994a2956e256d4f7dfb1bd024e1a412826ee7c1d1"
    sha256 sonoma:        "ab7cc55d6cfae2c77316093229ae3668f7e34d2d80713e4eec5f2c41f69983d2"
    sha256 arm64_linux:   "42071ee608cbbcfcc761fe4a9b18ed90499115dab3108c03ff72a27825a2beef"
    sha256 x86_64_linux:  "d04aa534933e21b7e469f009c76e5bde6e50ecadecbab3d6de4f134db8f7eef2"
  end

  depends_on "python@3.14"

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
    ENV["PYTHON"] = python3 = which("python3.14")
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
