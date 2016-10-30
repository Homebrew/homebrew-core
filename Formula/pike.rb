class Pike < Formula
  desc "Dynamic programming language"
  homepage "https://pike.lysator.liu.se"
  url "https://pike.lysator.liu.se/pub/pike/all/7.8.866/Pike-v7.8.866.tar.gz"
  sha256 "0b12e1a99bd8bdd9c8a2daa46e623ac718bc0737290236a0c8474091359b594e"
  revision 3

  bottle do
    sha256 "0f2a49f68021e5076182f457faaa042ce70214fb03157f60f807fb5307c13114" => :sierra
    sha256 "f39667a578587d3274fce318e92430c37755f5b42c4f608c80332d96ff630803" => :el_capitan
    sha256 "740fa259972600b23f8c7437d59c89f471f0c0a8fc0a2af2738be5f47fdb5069" => :yosemite
    sha256 "3dab476ddc379606639b5b44cddc19ec1764ac5227924a1e6b591f0961ba33b5" => :mavericks
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
  option "with-machine-code", "Enables machine code"

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

  fails_with :llvm do
    build 2335
    cause "Fails to build multiset.c, results in a Abort trap being caught."
  end

  def install
    args = ["--prefix=#{prefix}", "--without-bundles"]

    if MacOS.prefer_64_bit? && !build.build_32_bit?
      ENV.append "CFLAGS", "-m64"
      args << "--with-abi=64"
    else
      ENV.append "CFLAGS", "-m32"
      args << "--with-abi=32"
    end

    if build.without? "machine-code"
      args << "--without-machine-code"
    end

    ENV.j1

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
    path.write <<-EOS.undent
      int main() {
        for (int i=0; i<10; i++) { write("%d", i); }
        return 0;
      }
    EOS

    assert_equal "0123456789", shell_output("#{bin}/pike #{path}").strip
  end
end
