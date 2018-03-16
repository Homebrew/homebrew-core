# Based on:
# Apple Open Source: https://opensource.apple.com/source/cvs/cvs-45/
# MacPorts: https://trac.macports.org/browser/trunk/dports/devel/cvs/Portfile
# Creating a useful testcase: https://mrsrl.stanford.edu/~brian/cvstutorial/

class Cvs < Formula
  desc "Version control system"
  homepage "https://www.nongnu.org/cvs/"
  url "https://ftp.gnu.org/non-gnu/cvs/source/feature/1.12.13/cvs-1.12.13.tar.bz2"
  sha256 "78853613b9a6873a30e1cc2417f738c330e75f887afdaf7b3d0800cb19ca515e"
  revision 1

  bottle do
    sha256 "11b8be2fda1de3c8b77b20bdc283ceb12ba511826a0d3b79147dbfaeb83420db" => :high_sierra
    sha256 "01f9517d330037a248bc6d36c8127a4f99eb364a8a0d1cc5f8520cca261b7163" => :sierra
    sha256 "32dcf27cf028e270e826ba9850bde2f403f77c2c16a4b534d59cf68c0446e1fb" => :el_capitan
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
