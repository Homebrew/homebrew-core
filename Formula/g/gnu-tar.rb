class GnuTar < Formula
  desc "GNU version of the tar archiving utility"
  homepage "https://www.gnu.org/software/tar/"
  url "https://ftpmirror.gnu.org/gnu/tar/tar-1.35.tar.gz"
  mirror "https://ftp.gnu.org/gnu/tar/tar-1.35.tar.gz"
  sha256 "14d55e32063ea9526e057fbf35fcabd53378e769787eff7919c3755b02d2b57e"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4e3782b9393e2e53a1cccd9c1047c2fc43b81c34746b10755050d5d162b21269"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "731785debae0adb1e95cb3775f6b71f16ab39d710e84e9fb2f3fb02c69e57520"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83fe22ea67dab39a7b2bc533a5ff958e201f99e6d5bb335897d2013319060c0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1939dfc961ed8aaf821f40b70d17a8f02a59370e092a933747f1dbc2b309fed4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02a1aed6abdf277b926a056d95e6fd187a41b4aca6ec913588725d17af8996a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9a0d278cd686a626b45cbfd43aa8f34adbf8347c1f58c3849e9dc7f78016b4b"
    sha256 cellar: :any_skip_relocation, ventura:        "a5a14e7862c152e90e14c3efaf4973f0e93db2c24b23e793b7e2938ef4174ec7"
    sha256 cellar: :any_skip_relocation, monterey:       "cfc20759e66fb504327deba772787d6b9780b09c11c8fe64000cee054dbc9aa0"
    sha256                               arm64_linux:    "3d978a1e268ac4c54b0f56a2204abdf025a624352d47fb860e10b102088de8c7"
    sha256                               x86_64_linux:   "c990300939509bf4ad6eb70e19d5bf47d8812295bf591de75e84ca163942ced6"
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
    # fix commit, https://git.savannah.gnu.org/cgit/tar.git/commit/?id=8632df39, remove in next release
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "./bootstrap" if build.head?
    system "./configure", *args
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
    end
  end
end
