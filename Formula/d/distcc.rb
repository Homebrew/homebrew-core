class Distcc < Formula
  include Language::Python::Virtualenv

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
    rebuild 2
    sha256 arm64_sonoma:   "86f9db8cf49b2761bed7f067435d5e44a7e6d766f926d889b07feff6f0faf606"
    sha256 arm64_ventura:  "2e5d348a1fadf36a192c384d570935d3207c4328b56989429ccba71009218a65"
    sha256 arm64_monterey: "fbab64f137d740df58d38572b657f223ee7ac9b9b0bae4831a6a1d15b614a5c3"
    sha256 sonoma:         "622db90f14bcdefda607c55b5ac3591a851ee10b2a5824f1a847117839f4486b"
    sha256 ventura:        "1f1403908514f997b9adb2c7533c95d327e59af14d77debb6735020301cfaade"
    sha256 monterey:       "f45fc0328cf2e97468b13f407ac8dd594df7d456c55f24a7d077ace92777bd55"
    sha256 x86_64_linux:   "e8044112f0fb9eead14311e10e8ca49e8ff4d5eab6bd58c7ffb0a4bbd00aba42"
  end

  depends_on "python@3.12"

  resource "libiberty" do
    url "https://ftp.debian.org/debian/pool/main/libi/libiberty/libiberty_20210106.orig.tar.xz"
    sha256 "9df153d69914c0f5a9145e0abbb248e72feebab6777c712a30f1c3b8c19047d4"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/d6/4f/b10f707e14ef7de524fe1f8988a294fb262a29c9b5b12275c7e188864aed/setuptools-69.5.1.tar.gz"
    sha256 "6c1fccdac05a97e598fb0ae3bbed5904ccb317337a51139dcd51453611bbb987"
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
    ENV["PYTHON"] = python3 = which("python3.12")
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
