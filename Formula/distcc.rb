class Distcc < Formula
  desc "Distributed compiler client and server"
  homepage "https://github.com/distcc/distcc/"
  url "https://github.com/distcc/distcc/releases/download/v3.4/distcc-3.4.tar.gz"
  sha256 "2b99edda9dad9dbf283933a02eace6de7423fe5650daa4a728c950e5cd37bd7d"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/distcc/distcc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "ae3e5f6ee6b7ce6b2db11d3f6710adade66ed52f9f90effa5fbc89cbcda5c7b1"
    sha256 arm64_monterey: "5c55152ee011c5ee9ee80d6dd8afc0459d10698336fe6acd1d5885154925c0d9"
    sha256 arm64_big_sur:  "93ab4921b118e8da7928a8e260c57dea0214c548d514b3085cbe0e97a9ce44fe"
    sha256 ventura:        "c19d7cb1f54bde33fe9ff79ca8ba1772091315c583f6cf21cf4ceaf826886558"
    sha256 monterey:       "87f38e3222a99da6532491198e14568fefd8e5b68e6fbf850d990f4f9a8c0f3b"
    sha256 big_sur:        "0c13ddef45e9c4b0b8206c665debab7b20607e60f2eecd6416e6b7b96b7eb2f5"
    sha256 x86_64_linux:   "f62a2ac4db8798cca95136213d540115e239e63c5dd97d70757e06c6eae98032"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.11"

  resource "libiberty" do
    url "https://ftp.debian.org/debian/pool/main/libi/libiberty/libiberty_20210106.orig.tar.xz"
    sha256 "9df153d69914c0f5a9145e0abbb248e72feebab6777c712a30f1c3b8c19047d4"
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
    run [opt_bin/"distcc", "--allow=192.168.0.1/24"]
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
    if OS.mac?
      ENV["DISTCC_POTENTIAL_HOSTS"] = "localhost"
      assert_match "Homebrew\n", shell_output("#{bin}/pump make")
    end
  end
end
