class MinimalRacket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "https://racket-lang.org/"
  url "https://mirror.racket-lang.org/installers/7.4/racket-minimal-7.4-src-builtpkgs.tgz"
  sha256 "c819608cee733c98241e329274f3567956baaaa7283e061e45342f533bd9a51b"

  bottle do
    cellar :any
    sha256 "54682774edc9d7818bb3f13b24b782c351876c2f44573a1d5c0b042d1b17c5c9" => :mojave
    sha256 "b88127d2552cf2d11ade45f6e7deffd871cd27c1bf5937dae571dc8ba931c98b" => :high_sierra
    sha256 "e76979bfea6f2c0549e4393af622a6d73b174b6323320d253873022643bab4c2" => :sierra
  end

  # needed to fix issue with a pragma in the macOS 10.15 headers
  # see https://github.com/racket/racket/commit/27c1847ce8e77b4d0024c10a67ecd2316dbbda33
  # TODO: remove me in the next release!
  patch :DATA

  # these two files are amended when (un)installing packages
  skip_clean "lib/racket/launchers.rktd", "lib/racket/mans.rktd"

  def install
    cd "src" do
      args = %W[
        --disable-debug
        --disable-dependency-tracking
        --enable-macprefix
        --prefix=#{prefix}
        --man=#{man}
        --sysconfdir=#{etc}
      ]

      system "./configure", *args
      system "make"
      system "make", "install"
    end

    # configure racket's package tool (raco) to do the Right Thing
    # see: https://docs.racket-lang.org/raco/config-file.html
    inreplace etc/"racket/config.rktd" do |s|
      s.gsub!(
        /\(bin-dir\s+\.\s+"#{Regexp.quote(bin)}"\)/,
        "(bin-dir . \"#{HOMEBREW_PREFIX}/bin\")",
      )
      s.gsub!(
        /\n\)$/,
        "\n      (default-scope . \"installation\")\n)",
      )
    end
  end

  def caveats; <<~EOS
    This is a minimal Racket distribution.
    If you want to build the DrRacket IDE, you may run
      raco pkg install --auto drracket

    The full Racket distribution is available as a cask:
      brew cask install racket
  EOS
  end

  test do
    output = shell_output("#{bin}/racket -e '(displayln \"Hello Homebrew\")'")
    assert_match /Hello Homebrew/, output

    # show that the config file isn't malformed
    output = shell_output("'#{bin}/raco' pkg config")
    assert $CHILD_STATUS.success?
    assert_match Regexp.new(<<~EOS), output
      ^name:
        #{version}
      catalogs:
        https://download.racket-lang.org/releases/#{version}/catalog/
        https://pkgs.racket-lang.org
        https://planet-compats.racket-lang.org
      default-scope:
        installation
    EOS
  end
end
__END__
diff --git a/racket/collects/compiler/private/xform.rkt b/racket/collects/compiler/private/xform.rkt
index 68fc0a6571..1a23cde8a2 100644
--- a/collects/compiler/private/xform.rkt
+++ b/collects/compiler/private/xform.rkt
@@ -495,7 +495,7 @@
           (and precompiled-header
                (open-input-file (change-extension precompiled-header #".e"))))
         (define re:boring #rx#"^(?:(?:[ \t]*)|(?:# .*)|(?:#line .*)|(?:#pragma implementation.*)|(?:#pragma interface.*)|(?:#pragma once)|(?:#pragma warning.*)|(?:#ident.*))$")
-        (define re:uninteresting #rx#"^(?:(?:[ \t]*)|(?:# .*)|(?:#line .*)|(?:#pragma implementation.*)|(?:#pragma interface.*)|(?:#pragma once)|(?:#pragma GCC diagnostic.*)|(?:#pragma warning.*)|(?:#ident.*))$")
+        (define re:uninteresting #rx#"^(?:(?:[ \t]*)|(?:# .*)|(?:#line .*)|(?:#pragma implementation.*)|(?:#pragma interface.*)|(?:#pragma once)|(?:#pragma (?:GCC|clang) diagnostic.*)|(?:#pragma warning.*)|(?:#ident.*))$")
         (define (skip-to-interesting-line p)
           (let ([l (read-bytes-line p 'any)])
             (cond
@@ -506,7 +506,7 @@
         (when recorded-cpp-in
           ;; Skip over common part:
           (let loop ([lpos 1])
-            (let ([pl (read-bytes-line recorded-cpp-in 'any)])
+            (let ([pl (skip-to-interesting-line recorded-cpp-in)])
               (unless (eof-object? pl)
                 (let ([l (skip-to-interesting-line (car cpp-process))])
                   (unless (equal? pl l)
@@ -4073,11 +4073,18 @@
             (cond
               [(null? e) (values (reverse result) null)]
               [(pragma? (car e))
-               (unless (null? result)
-                 (error 'pragma "unexpected pragma: ~a at: ~a:~a"
-                        (pragma-s (car e))
-                        (pragma-file (car e)) (pragma-line (car e))))
-               (values (list (car e)) (cdr e))]
+               (cond
+                 [(null? result)
+                  (values (list (car e)) (cdr e))]
+                 [(and (pair? (cdr e))
+                       (eq? semi (tok-n (cadr e))))
+                  ;; Swap order of pragma and terminating semicolon
+                  (values (reverse (cons (cadr e) result))
+                          (cons (car e) (cddr e)))]
+                 [else
+                  (error 'pragma "unexpected pragma: ~a at: ~a:~a"
+                         (pragma-s (car e))
+                         (pragma-file (car e)) (pragma-line (car e)))])]
               [(compiler-pragma? e)
                (unless (null? result)
                  (error 'pragma "unexpected MSVC compiler pragma"))__END__
