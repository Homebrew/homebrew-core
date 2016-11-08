class Dpkg < Formula
  desc "Debian package management system"
  homepage "https://wiki.debian.org/Teams/Dpkg"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/dpkg/dpkg_1.18.13.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/d/dpkg/dpkg_1.18.13.tar.xz"
  sha256 "51f98e37ccf21c8df1ba919d6670286bc48b905ff20d6e4cf9620d9b318a3990"

  bottle do
    sha256 "19ab2c45a537e1ccc6e3e3a99afc79c1f7a403b6882e1a407bbf6ba8520c5cbc" => :sierra
    sha256 "eadd5648ad3fa63bfda5d9c9c000df8e599536d5e612c93311e09141271f1904" => :el_capitan
    sha256 "355293cb511d0101230a33150373d8247d322b41317f272763c9cc1f02b098f4" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gnu-tar"
  depends_on "xz" # For LZMA

  def install
    # We need to specify a recent gnutar, otherwise various dpkg C programs will
    # use the system "tar", which will fail because it lacks certain switches.
    ENV["TAR"] = Formula["gnu-tar"].opt_bin/"gtar"

    # Theoretically, we could reinsert a patch here submitted upstream previously
    # but the check for PERL_LIB remains in place and incompatible with Homebrew.
    # Using an env and scripting is a solution less likely to break over time.
    # Both variables need to be set. One is compile-time, the other run-time.
    ENV["PERL_LIBDIR"] = libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{libexec}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-dselect",
                          "--disable-linker-optimisations",
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

  def caveats; <<-EOS.undent
    This installation of dpkg is not configured to install software, so
    commands such as `dpkg -i`, `dpkg --configure` will fail.
    EOS
  end

  test do
    # Do not remove the empty line from the end of the control file
    # All deb control files MUST end with an empty line
    (testpath/"test/data/homebrew.txt").write "brew"
    (testpath/"test/DEBIAN/control").write <<-EOS.undent
      Package: test
      Version: 1.40.99
      Architecture: amd64
      Description: I am a test
      Maintainer: Dpkg Developers <test@test.org>

    EOS
    system bin/"dpkg", "-b", testpath/"test", "test.deb"
    assert File.exist?("test.deb")

    rm_rf "test"
    system bin/"dpkg", "-x", "test.deb", testpath
    assert File.exist?("data/homebrew.txt")
  end
end
