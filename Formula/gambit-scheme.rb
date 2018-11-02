class GambitScheme < Formula
  desc "Gambit Scheme"
  homepage "https://gambitscheme.org"
  url "https://github.com/gambit/gambit.git", :tag => "v4.9.0"

  depends_on "gcc@6"
  depends_on "openssl" => :optional

  def install
    args = %W[--prefix=#{prefix}]

    ENV["CC"] = Formula["gcc@6"].bin/"gcc-6"

    if build.with? "disable-ssl-verification"
      system "sed -i -e 's#SSL_CTX_set_default_verify_paths (c->tls_ctx);##g' lib/os_io.c"
      system "sed -i -e 's#SSL_CTX_set_verify (c->tls_ctx, SSL_VERIFY_PEER, NULL);##g' lib/os_io.c"
    end

    if build.with? "single-host"
      args << "--enable-single-host"
    end

    if build.with? "multiple-versions"
      args << "--enable-multiple-versions"
    end

    if build.with? "gerbil-options"
      args << "--enable-default-runtime-options=f8,-8,t8"
    end

    if build.with? "poll"
      args << "--enable-poll"
    end

    if build.with? "openssl"
      args << "--enable-openssl"
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize

    bin.install "gsc/gsc"
    bin.install "gsi/gsi"

    %w[ gambcomp-C
        gambcomp-java
        gambcomp-js
        gambcomp-php
        gambcomp-python
        gambcomp-ruby
        gambdoc].each do |l|
      bin.install Dir["bin/#{l}"]
    end

    %w[ gsi-script
        scheme-ieee-1178-1990
        scheme-r4rs
        scheme-r5rs
        scheme-srfi-0
        six
        six-script ].each do |l|
      bin.install_symlink "gsi" => l.to_s
    end

    %w[gambit.html gambit.pdf gambit.txt].each do |d|
      doc.install Dir["doc/#{d}"]
    end

    %w[gambit-not409000.h gambit.h].each do |i|
      include.install Dir["include/#{i}"]
    end

    %w[gambit.info gambit.info-1 gambit.info-2 gambit.info-3].each do |i|
      info.install Dir["info/#{i}"]
    end

    %w[ _std#.scm
        _syntax-case-xform.scm
        _syntax-rules-xform.scm
        _syntax-xform.scm
        _thread#.scm
        digest#.scm
        libgambit.ar4rs#.scm
        _assert#.scm
        _codegen#.scm
        _define-syntax.scm
        _eval#.scm
        _gambit#.scm
        _gambit.c
        _gambitgsc.c
        _gambitgsi.c
        _io#.scm
        _kernel#.scm
        _nonstd#.scm
        _num#.scm
        _repl#.scm
        _syntax-boot.scm
        _syntax-case-xform-boot.scm
        _syntax-common.scm
        _syntax-pattern.scm
        _syntax-template.scm
        _syntax-xform-boot.scm
        _syntax.scm
        _system#.scm
        _with-syntax-boot.scm
        _x86#.scm
        digest.scm
        gambit#.scm
        libgambitgsc.a
        libgambitgsi.a
        r5rs#.scm
        syntax-case.scm
        _asm#.scm ].each do |l|
      lib.install Dir["lib/#{l}"]
    end

    bin.install_symlink "bin/gsc" => "gsc-script"
    prefix.install_symlink prefix => "#{prefix}/v#{version}"
  end

  test do
    output = `#{bin}/gsi -e "(for-each write '(0 1 2 3 4 5 6 7 8 9))"`
    assert_equal "0123456789", output
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
