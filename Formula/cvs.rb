# Based on:
# Apple Open Source: https://opensource.apple.com/source/cvs/cvs-45/
# MacPorts: https://trac.macports.org/browser/trunk/dports/devel/cvs/Portfile
# Creating a useful testcase: https://mrsrl.stanford.edu/~brian/cvstutorial/

class Cvs < Formula
  desc "Version control system"
  homepage "http://cvs.nongnu.org/"
  url "https://ftp.gnu.org/non-gnu/cvs/source/feature/1.12.13/cvs-1.12.13.tar.bz2"
  sha256 "78853613b9a6873a30e1cc2417f738c330e75f887afdaf7b3d0800cb19ca515e"
  revision 1

  bottle do
    sha256 "b8604bdb205a892e4cab5ea86b825080aa22ea5c5bb6e9df9b2b65a67555a105" => :high_sierra
    sha256 "fd41f323c862928ecdd5830f9174b860d5aeb3f454047e62ecefa0436a564161" => :sierra
    sha256 "d81b370b83adb2b33a2d6c8b377fc8ca98225768b3c67abdd9e3beaf1d0e9808" => :el_capitan
  end

  keg_only :provided_until_xcode5

  patch :p0 do
    url "https://opensource.apple.com/tarballs/cvs/cvs-45.tar.gz"
    sha256 "4d200dcf0c9d5044d85d850948c88a07de83aeded5e14fa1df332737d72dc9ce"
    apply "patches/PR5178707.diff",
          "patches/ea.diff",
          "patches/endian.diff",
          "patches/fixtest-client-20.diff",
          "patches/fixtest-recase.diff",
          "patches/i18n.diff",
          "patches/initgroups.diff",
          "patches/nopic.diff",
          "patches/remove-libcrypto.diff",
          "patches/remove-info.diff",
          "patches/tag.diff",
          "patches/zlib.diff"
  end

  # Fixes error: 'Illegal instruction: 4'; '%n used in a non-immutable format string' on 10.13
  # Patches the upstream-provided gnulib on all platforms as is recommended
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/24118ec737c7/cvs/vasnprintf-high-sierra-fix.diff"
    sha256 "affa485332f66bb182963680f90552937bf1455b855388f7c06ef6a3a25286e2"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--sysconfdir=#{etc}",
                          "--with-gssapi",
                          "--enable-pam",
                          "--enable-encryption",
                          "--with-external-zlib",
                          "--enable-case-sensitivity",
                          "--with-editor=vim",
                          "ac_cv_func_working_mktime=no"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    cvsroot = testpath/"cvsroot"
    cvsroot.mkpath
    system "#{bin}/cvs", "-d", cvsroot, "init"

    mkdir "cvsexample" do
      ENV["CVSROOT"] = cvsroot
      system "#{bin}/cvs", "import", "-m", "dir structure", "cvsexample", "homebrew", "start"
    end
  end
end
