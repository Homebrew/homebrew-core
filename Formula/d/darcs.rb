class Darcs < Formula
  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "https://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.18.5/darcs-2.18.5.tar.gz"
  sha256 "e310692989e313191824f532a26c5eae712217444214266503d5eb5867f951ab"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "60ea4e045b5df028037e96e75d87ec49abf683f86fe06783a62c9252c12b6857"
    sha256 cellar: :any,                 arm64_sequoia: "c6e054554c172fd77903e34d991250008b7189cc169fb598adf6bf9a4b5c956c"
    sha256 cellar: :any,                 arm64_sonoma:  "fc15e6c6b4f25d8bc96517ca1fc1c03fecf6e5bb344a40e7b39c467507c9ab5f"
    sha256 cellar: :any,                 sonoma:        "a9a5404dcb578f8169bc4c640ca8eb7c4ee85bc2165eadb15c6b3abcc80ebcc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b59ab9ff70e3a68a4e48f44070a4f9a2cc79270aa9678b90138b913fb4b00ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "038ccd3331bc1203def1a825cbf497efd76069efea5d45fa4a2a3fb40badbd6c"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
    # Workaround to build with GHC >= 9.12
    args = ["--allow-newer=base"]

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
