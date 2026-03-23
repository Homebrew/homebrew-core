class Darcs < Formula
  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "https://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.18.5/darcs-2.18.5.tar.gz"
  sha256 "e310692989e313191824f532a26c5eae712217444214266503d5eb5867f951ab"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "b136e4dddca375c9cbbcc9a7dbb428e39d76e5281efd34bf6f8d0242386d9aef"
    sha256 cellar: :any,                 arm64_sequoia: "aa20414a1524f322745264585f1b7e4ab9c3eb7bd5a0e41bff3f5bb8f121df3d"
    sha256 cellar: :any,                 arm64_sonoma:  "e5d6d511c4cbbbdc6e7d7e79f02315cd5eae3b6e5c791599b20ebecb401cdf20"
    sha256 cellar: :any,                 sonoma:        "9735bb1d1d9a86199a42b26815311db4f9c1953e1329ffe2ded96a6a14437f38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "025db6a2cfdc508f1acf571bc802f4d93519b4877a79869b826427d83b2d5b83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d38c3251fefc0ff7e1dfbdf9ed4455eac8b4a001a26a1dc7cfeda90c646f7717"
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
