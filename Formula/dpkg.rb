class Dpkg < Formula
  desc "Debian package management system"
  homepage "https://wiki.debian.org/Teams/Dpkg"
  # Please always keep the Homebrew mirror as the primary URL as the
  # dpkg site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://dl.bintray.com/homebrew/mirror/dpkg-1.19.0.4.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/dpkg/dpkg_1.19.0.4.tar.xz"
  sha256 "98a66bb19012f9bde848e1e02903fe411dd0b9e61921108ee4323c4167e6990a"

  bottle do
    sha256 "4514edf429e5c0ba98d68ee24458e450ee11ddc05003b7c00836c6bf7750451f" => :high_sierra
    sha256 "8a691e148760a8bf970a8dfc4190010e70200a5810a0013c1332f2082f069076" => :sierra
    sha256 "a46a6de14534cc3429261820e3c10d39902196ed64ad290f1d5b55d62c46d449" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gnu-tar"
  depends_on "gpatch"
  depends_on :perl => "5.20"
  depends_on "xz" # For LZMA

  def install
    # We need to specify a recent gnutar, otherwise various dpkg C programs will
    # use the system "tar", which will fail because it lacks certain switches.
    ENV["TAR"] = Formula["gnu-tar"].opt_bin/"gtar"

    # Since 1.18.24 dpkg mandates the use of GNU patch to prevent occurrences
    # of the CVE-2017-8283 vulnerability.
    # http://www.openwall.com/lists/oss-security/2017/04/20/2
    ENV["PATCH"] = Formula["gpatch"].opt_bin/"patch"

    # Theoretically, we could reinsert a patch here submitted upstream previously
    # but the check for PERL_LIB remains in place and incompatible with Homebrew.
    # Using an env and scripting is a solution less likely to break over time.
    # Both variables need to be set. One is compile-time, the other run-time.
    ENV["PERL_LIBDIR"] = libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{libexec}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-dselect",
                          "--disable-start-stop-daemon"
    system "make"
    system "make", "install"

    bin.install Dir[libexec/"bin/*"]
    man.install Dir[libexec/"share/man/*"]
    (lib/"pkgconfig").install_symlink Dir[libexec/"lib/pkgconfig/*.pc"]
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])

    (buildpath/"dummy").write "Vendor: dummy\n"
    (etc/"dpkg/origins").install "dummy"
    (etc/"dpkg/origins").install_symlink "dummy" => "default"
  end

  def post_install
    (var/"lib/dpkg").mkpath
    (var/"log").mkpath
  end

  def caveats; <<~EOS
    This installation of dpkg is not configured to install software, so
    commands such as `dpkg -i`, `dpkg --configure` will fail.
    EOS
  end

  test do
    # Do not remove the empty line from the end of the control file
    # All deb control files MUST end with an empty line
    (testpath/"test/data/homebrew.txt").write "brew"
    (testpath/"test/DEBIAN/control").write <<~EOS
      Package: test
      Version: 1.40.99
      Architecture: amd64
      Description: I am a test
      Maintainer: Dpkg Developers <test@test.org>

    EOS
    system bin/"dpkg", "-b", testpath/"test", "test.deb"
    assert_predicate testpath/"test.deb", :exist?

    rm_rf "test"
    system bin/"dpkg", "-x", "test.deb", testpath
    assert_predicate testpath/"data/homebrew.txt", :exist?
  end
end
