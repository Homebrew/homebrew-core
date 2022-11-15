class GnuTar < Formula
  desc "GNU version of the tar archiving utility"
  homepage "https://www.gnu.org/software/tar/"
  url "https://ftp.gnu.org/gnu/tar/tar-1.34.tar.gz"
  mirror "https://ftpmirror.gnu.org/tar/tar-1.34.tar.gz"
  sha256 "03d908cf5768cfe6b7ad588c921c6ed21acabfb2b79b788d1330453507647aed"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "828558d1246976fe4ea4f2d5e7395b2e768c7b1874e42c959a4416f424dfc991"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d30acbafc1fafafd0e20b926fae992e246c8eb7f833ef349b9af330ca1c104f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "984b478a4567b7435d3e5ccda4adecea05b076f7d906a5e38a2941b125cf9182"
    sha256 cellar: :any_skip_relocation, ventura:        "35530248d44c4d449cd1945e94db2a659455927a41ee40628b92e19e5908b8ac"
    sha256 cellar: :any_skip_relocation, monterey:       "50e95002e10bc01900248602282baf407d2984ee0037bce5ae7aa179c052e393"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c70eed37ee410279978ea44a4444e8116ddb303626c592545ebf50fd65ae423"
    sha256 cellar: :any_skip_relocation, catalina:       "1db42ebdaa7724d0fb55e861a4e2ac59b0736f9c4d183bd628c658b70c395e92"
    sha256                               x86_64_linux:   "f23b93a35c0a48f57fd6e2f8eb6edb7688b6e13ab7d8124d6053422738a16229"
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
    ]

    args << if OS.mac?
      "--program-prefix=g"
    else
      "--without-selinux"
    end
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
