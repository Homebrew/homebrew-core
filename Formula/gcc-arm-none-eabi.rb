class GccArmNoneEabi < Formula
  desc "GNU Arm Embedded Toolchain"
  homepage "https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm"
  url "https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2019q3/RC1.1/gcc-arm-none-eabi-8-2019-q3-update-src.tar.bz2"
  version "8-2019-q3-update"
  sha256 "e8a8ddfec47601f2d83f1d80c0600f198476f227102121c8d6a5a781d0c2eeef"

  env :std

  depends_on "gmp" # 6.1.0 6.1.2
  depends_on "isl" # 0.18 0.21
  depends_on "libelf" # 0.8.13 0.8.13
  depends_on "libmpc" # 1.0.3 1.1.0
  depends_on "mpfr" # 3.1.4 4.0.2

  uses_from_macos "expat" # 2.1.1 2.2.9
  uses_from_macos "libiconv" # 1.14 1.16
  uses_from_macos "zlib" # 1.2.8 1.2.11

  def install
    cd "src" do
      Dir.glob("*.tar.bz2") { |file| system "tar", "xf", file }
    end

    inreplace "build-common.sh" do |s|
      #s.gsub! /^clean_env$/, ""
      s.gsub! "INSTALLDIR_NATIVE=$ROOT/install-native", "INSTALLDIR_NATIVE=#{prefix}"
      s.gsub! "INSTALLDIR_NATIVE_DOC=$ROOT/install-native/share/doc/gcc-arm-none-eabi", "INSTALLDIR_NATIVE_DOC=#{doc}"

      # Do not update version during build
      # see: https://bugs.launchpad.net/gcc-arm-embedded/+bug/1741994
      s.gsub! "$GCC_VER_NAME-$RELEASEVER", version
    end

    inreplace "build-toolchain.sh" do |s|
      s.gsub! "rm -rf $INSTALLDIR_NATIVE && mkdir -p $INSTALLDIR_NATIVE", ""

      s.gsub! "--prefix=$INSTALLDIR_NATIVE", "--prefix=#{prefix}"
      s.gsub! "--libexecdir=$INSTALLDIR_NATIVE/lib", "--libexecdir=#{libexec}"
      s.gsub! "--infodir=$INSTALLDIR_NATIVE_DOC/info", "--infodir=#{info}"
      s.gsub! "--mandir=$INSTALLDIR_NATIVE_DOC/man", "--mandir=#{man}"
      s.gsub! "--htmldir=$INSTALLDIR_NATIVE_DOC/html", "--htmldir=#{doc}/html"
      s.gsub! "--pdfdir=$INSTALLDIR_NATIVE_DOC/pdf", "--pdfdir=#{doc}/pdf"
      s.gsub! "--with-sysroot=$INSTALLDIR_NATIVE/arm-none-eabi", "--with-sysroot=#{prefix}/arm-none-eabi"

      # Task III-11, IV-8, V-0 and V-1 generates package which we don't need
      s.gsub! /^echo Task \[III-11\].*?popd/m, ""
      s.gsub! /^echo Task \[IV-8\].*?popd/m, ""
      s.gsub! /^echo Task \[V-0\].*?popd/m, ""
      s.gsub! /^echo Task \[V-1\].*?popd/m, ""
    end

    system "./build-toolchain.sh", "--skip_steps=manual"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arm-none-eabi-gcc --version")
  end
end
