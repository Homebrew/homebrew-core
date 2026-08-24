class Darcs < Formula
  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "https://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.18.5/darcs-2.18.5.tar.gz"
  sha256 "e310692989e313191824f532a26c5eae712217444214266503d5eb5867f951ab"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 3
    sha256 cellar: :any, arm64_tahoe:   "15d6477c7276b36495d448682824d46e22025f40fbc2c06db2b6555b3474e41c"
    sha256 cellar: :any, arm64_sequoia: "f6e5bd3f5eeab927c43ca8b9c4a5ec1823f27ba058aaa31d66b355a365a16b19"
    sha256 cellar: :any, arm64_sonoma:  "fde15e80ef3f49467e062af834e7d9af58b67f5fe7bd0bb6bc808da699aeb947"
    sha256 cellar: :any, sonoma:        "e3c905d43578cb3e607548eaae2ad32879138bcab5be52bf91a20b1413796a55"
    sha256 cellar: :any, arm64_linux:   "1c21d68b8e4f654c0567ba5b256aaec16bbd69c6d485b11ca2c031213b909675"
    sha256 cellar: :any, x86_64_linux:  "f8b364ca09894409de33e8c24f85546676a0cdec52f05c8ee76f90399ea305f4"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Backport fixes for newer GHC[^1] and Cabal[^2]. Darcs uses a different
  # patch file format and cannot be applied with the external patch DSL.
  #
  # * darcs diff --hash 32646b190e019de21a103e950c4eccdd66f7eadc
  # * darcs diff --hash 50d9b0b402a896c83aa7929a50a0e0449838600f
  # * darcs diff --hash 8da98f5de14034aa79a2860212fa34e99585e188
  #
  # [^1]: https://bugs.darcs.net/patch2422
  # [^2]: https://bugs.darcs.net/patch2426
  patch :DATA

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell,hashable:ghc-bignum"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    mkdir "my_repo" do
      system bin/"darcs", "init"
      Pathname("foo").write "hello homebrew!"
      system bin/"darcs", "add", "foo"
      system bin/"darcs", "record", "-am", "add foo", "--author=homebrew"
    end
    system bin/"darcs", "get", "my_repo", "my_repo_clone"
    assert_equal "hello homebrew!", (testpath/"my_repo_clone/foo").read
  end
end

__END__
diff -rN -u old-darcs.net/darcs.cabal new-darcs.net/darcs.cabal
--- old-darcs.net/darcs.cabal	2025-01-05 10:09:26
+++ new-darcs.net/darcs.cabal	2025-01-05 10:09:26
@@ -123,7 +123,7 @@
 -- ----------------------------------------------------------------------

 custom-setup
-    setup-depends: base      >= 4.10 && < 4.20,
+    setup-depends: base      >= 4.10 && < 4.21,
                    Cabal     >= 2.4 && < 3.11,
                    process   >= 1.2.3.0 && < 1.7,
                    filepath  >= 1.4.1 && < 1.5.0.0,
@@ -412,7 +412,7 @@
     else
       build-depends:  unix >= 2.7.1.0 && < 2.9

-    build-depends:    base              >= 4.10 && < 4.20,
+    build-depends:    base              >= 4.10 && < 4.21,
                       safe              >= 0.3.20 && < 0.4,
                       stm               >= 2.1 && < 2.6,
                       binary            >= 0.5 && < 0.11,
diff -rN -u old-darcs.net/Setup.hs new-darcs.net/Setup.hs
--- old-darcs.net/Setup.hs	2025-01-05 10:24:34
+++ new-darcs.net/Setup.hs	2025-01-05 10:24:34
@@ -8,7 +8,7 @@
 import Distribution.Package ( packageVersion )
 import Distribution.Version( Version )
 import Distribution.Simple.LocalBuildInfo
-         ( LocalBuildInfo(..), absoluteInstallDirs )
+         ( LocalBuildInfo(..), absoluteInstallDirs, buildDir )
 import Distribution.Simple.InstallDirs (mandir, CopyDest (NoCopyDest))
 import Distribution.Simple.Setup
     (buildVerbosity, copyDest, copyVerbosity, fromFlag,
diff -rN -u old-darcs.net/darcs.cabal new-darcs.net/darcs.cabal
--- old-darcs.net/darcs.cabal	2025-01-05 10:24:34
+++ new-darcs.net/darcs.cabal	2025-01-05 10:24:34
@@ -124,7 +124,7 @@

 custom-setup
     setup-depends: base      >= 4.10 && < 4.21,
-                   Cabal     >= 2.4 && < 3.11,
+                   Cabal     >= 2.4 && < 3.13,
                    process   >= 1.2.3.0 && < 1.7,
                    filepath  >= 1.4.1 && < 1.5.0.0,
                    directory >= 1.2.7 && < 1.4
