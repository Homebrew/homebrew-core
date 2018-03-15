class Pike < Formula
  desc "Dynamic programming language"
  homepage "https://pike.lysator.liu.se"
  url "https://pike.lysator.liu.se/pub/pike/all/8.0.498/Pike-v8.0.498.tar.gz"
  sha256 "b14ceccb26f37dbd9e078d87648a95f0501f290e89ae9b8197b2376d13eb1f2b"

  bottle do
    sha256 "9b3c1d8c9a1eceef90ce1bfe78137b0ccd726ec5dfc12f9746a471c5e855f92a" => :high_sierra
    sha256 "c8abc1e8fcc26523b257cd2144c22a27ed6063c07e33193c70e3d0898c94fa86" => :sierra
    sha256 "1ecfea274c44b5d087003b51acb934c4c3cc8494667cbaa4f6d57c1e919a2e20" => :el_capitan
  end

  option "with-gettext", "Include Gettext support"
  option "with-gdbm", "Include Gdbm support"
  option "with-gtk2", "Include GTK2 support"
  option "with-mysql", "Include Mysql support"
  option "with-pcre", "Include Regexp.PCRE support"
  option "with-sdl", "Include SDL support"
  option "with-sane", "Include Sane support"
  option "with-pdf", "Include PDF support"
  option "with-gl", "Include GL support"
  option "with-all", "Include all features"

  depends_on "nettle"
  depends_on "gmp"
  depends_on "pcre"
  depends_on :x11 => :optional
  depends_on "libtiff" => :recommended

  # optional dependencies
  depends_on "gettext"       if build.with?("gettext") || build.with?("all")
  depends_on "gdbm"          if build.with?("gdbm")    || build.with?("all")
  depends_on "gtk+"          if build.with?("gtk2")    || build.with?("all")
  depends_on "mysql"         if build.with?("mysql")   || build.with?("all")
  depends_on "sdl"           if build.with?("sdl")     || build.with?("all")
  depends_on "sane-backends" if build.with?("sane")    || build.with?("all")
  depends_on "pdflib-lite"   if build.with?("pdf")     || build.with?("all")
  depends_on "mesalib-glw"   if build.with?("gl")      || build.with?("all")

  def install
    args = ["--prefix=#{prefix}", "--without-bundles"]

    if MacOS.prefer_64_bit?
      ENV.append "CFLAGS", "-m64"
      args << "--with-abi=64"
    else
      ENV.append "CFLAGS", "-m32"
      args << "--with-abi=32"
    end

    ENV.deparallelize

    system "make", "CONFIGUREARGS='" + args.join(" ") + "'"

    # installation is complicated by some of brew's standard patterns.
    # hopefully these notes explain the reasons for diverging from
    # the path that most other formulae use.
    #
    # item 1
    #
    # basically, pike already installs itself naturally as brew would want
    # it; that is, if prefix=/Cellar, installation would create
    # /Cellar/pike/ver/bin and so forth. We could just go with that, but it's
    # possible that homebrew might change its layout and then the formula
    # would no longer work.
    #
    # so, rather than guessing at it, we do this alternate gyration, forcing
    # pike to install in a slightly nonstandard way (for pike, at least)
    #
    # item 2
    #
    # a second problem crops up because the during installation, the link
    # function tries to pull in stuff from lib/, which is really more like
    # what one would expect share or libexec in homebrew might be: pike
    # specific files, rather than shared libraries. we could approach this
    # in a similar fashion, but the result would be a really odd arrangement
    # for anyone remotely familar with standard pike installs.
    #
    # because there's no way to override the keg.link command, this formula
    # installs the whole pike install into prefix/libexec and then links the
    # man page and binary back into prefix/share and prefix/bin. not so
    # elegant, but that's the way brew works.
    system "make",  "install",
                    "prefix=#{libexec}",
                    "exec_prefix=#{libexec}",
                    "share_prefix=#{libexec}/share",
                    "lib_prefix=#{libexec}/lib",
                    "man_prefix=#{libexec}/man",
                    "include_path=#{libexec}/include",
                    "INSTALLARGS=--traditional"

    bin.install_symlink "#{libexec}/bin/pike"
    share.install_symlink "#{libexec}/share/man"
  end

  test do
    path = testpath/"test.pike"
    path.write <<~EOS
      int main() {
        for (int i=0; i<10; i++) { write("%d", i); }
        return 0;
      }
    EOS

    assert_equal "0123456789", shell_output("#{bin}/pike #{path}").strip
  end
end
