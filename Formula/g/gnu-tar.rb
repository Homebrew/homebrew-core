class GnuTar < Formula
  desc "GNU version of the tar archiving utility"
  homepage "https://www.gnu.org/software/tar/"
  url "https://ftpmirror.gnu.org/tar/tar-1.35.tar.gz"
  mirror "https://ftp.gnu.org/gnu/tar/tar-1.35.tar.gz"
  sha256 "14d55e32063ea9526e057fbf35fcabd53378e769787eff7919c3755b02d2b57e"
  license "GPL-3.0-or-later"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "98f372e8005b4f963a3c507f02ee212a9b20f9d9e4d8309c598ce331aab2e359"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "522c584c74e1ce6a685feed68e135353ac42262b9253d26d562fccf5b176df41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aa81f1c558381733e4506ec7b918d3cd39ad233ab74ed9b90bbeb6d709e47c21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "671e143eb99267953c1e2d2062e6902ac7c03c74d2ae879c7e38d86c7694f8dc"
    sha256 cellar: :any,                 arm64_linux:       "28bfccf86d4405037893cb37ca032b40589b0f0d2f09559baa3fbd3feedbd3c4"
    sha256 cellar: :any,                 x86_64_linux:      "a5fc1fa62890b5e1a228bf85207a56b6cccc28913b5a7d27901450d4c18bb48c"
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

  deny_network_access!

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
    # fix commit, https://git.savannah.gnu.org/cgit/tar.git/commit/?id=8632df39, remove in next release
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    if OS.linux? && build.stable?
      # Backport https://git.savannah.gnu.org/cgit/tar.git/commit/?id=08c3fc2e9337094aff01a511170fd35fdb8f1ee3
      %w[acl_get_file_at acl_set_file_at acl_delete_def_file_at].each do |function|
        inreplace "src/xattrs.c", function, "tar_#{function}"
      end
    end

    system "./bootstrap" if build.head?
    system "./configure", *args
    inreplace "lib/Makefile", /^DEFAULT_RMT_DIR = .+$/, "DEFAULT_RMT_DIR = /etc" if OS.linux?
    system "make", "install"

    return unless OS.mac?

    # Symlink the executable into libexec/gnubin as "tar"
    (libexec/"gnubin").install_symlink bin/"gtar" => "tar"
    (libexec/"gnuman/man1").install_symlink man1/"gtar.1" => "tar.1"
    (libexec/"gnubin").install_symlink "../gnuman" => "man"
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
      assert_match "--rmt-command=/etc/rmt", shell_output("#{bin}/tar --show-defaults")
      assert_path_exists libexec/"rmt"
    end
  end
end
