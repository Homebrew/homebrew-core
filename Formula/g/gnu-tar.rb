class GnuTar < Formula
  desc "GNU version of the tar archiving utility"
  homepage "https://www.gnu.org/software/tar/"
  url "https://ftp.gnu.org/gnu/tar/tar-1.35.tar.gz"
  mirror "https://ftpmirror.gnu.org/tar/tar-1.35.tar.gz"
  sha256 "14d55e32063ea9526e057fbf35fcabd53378e769787eff7919c3755b02d2b57e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15a0dbc1fe67cae4498891493686afca6d745b001a2913760ce79cd52c918079"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b5debb34f53626f09c119c96ab75e46dfcc9c816ca5ccbf4ce1b051251c3752"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78bbae315786562366b35a1c1d25c391824281aab63421e4243ec927dbe647b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98ce20547135be57ef9ee9b6e85df5081ba8b907f113c6d19b3e4a296b3930fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "da82f5abafab8ba2bfc25a33e500a546985e0b2789ea915d7ad05292b41a373b"
    sha256 cellar: :any_skip_relocation, ventura:        "5078709c3c1643d2ac42da4fc354baee127d06e4a4f8b04c9770867ec5166188"
    sha256 cellar: :any_skip_relocation, monterey:       "b083b4ca16eea4b23615ce1b90b7e1a3ee52dd90cd5a4275567cb0ea55339ee4"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7947a84f5bd5458a1faf9854a90d788c7661a6aba37b7ff7f8fba1e9d04ac24"
    sha256                               x86_64_linux:   "5209eb2c2693093b26bc232c09df1caf0b5254f9a2003aa88b81a7c7f9f2391a"
  end

  head do
    url "https://git.savannah.gnu.org/git/tar.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  on_linux do
    depends_on "acl"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --disable-nls
    ]

    args << if OS.mac?
      "--program-prefix=g"
    else
      "--without-selinux"
    end

    # iconv is detected during configure process but -liconv is missing
    # from LDFLAGS as of gnu-tar 1.35. Remove once iconv linking works
    # without this. See https://savannah.gnu.org/bugs/?64441.
    # fix commit, http://git.savannah.gnu.org/cgit/tar.git/commit/?id=8632df39, remove in next release
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"

    return unless OS.mac?

    # Symlink the executable into libexec/gnubin as "tar"
    (libexec/"gnubin").install_symlink bin/"gtar" => "tar"
    (libexec/"gnuman/man1").install_symlink man1/"gtar.1" => "tar.1"
    libexec.install_symlink "gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        GNU "tar" has been installed as "gtar".
        If you need to use it as "tar", you can add a "gnubin" directory
        to your PATH from your bashrc like:

            PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    (testpath/"test").write("test")
    if OS.mac?
      system bin/"gtar", "-czvf", "test.tar.gz", "test"
      assert_match "test", shell_output("#{bin}/gtar -xOzf test.tar.gz")
      assert_match "test", shell_output("#{opt_libexec}/gnubin/tar -xOzf test.tar.gz")
    else
      system bin/"tar", "-czvf", "test.tar.gz", "test"
      assert_match "test", shell_output("#{bin}/tar -xOzf test.tar.gz")
    end
  end
end
