class Darcs < Formula
  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "https://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.18.5/darcs-2.18.5.tar.gz"
  sha256 "e310692989e313191824f532a26c5eae712217444214266503d5eb5867f951ab"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9ef3739cd7aef89964796218a15346faed915fbfcd207775c54809560b2bea6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "507dfc31c10438735098621aed6c75916d2b807bc7a72f957dbc0e808ff65916"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2772f85e77f266ccecd9f8c5dbabf09b965b789d92b1d7c202989317cb832e7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "22caed7f5b40475b198b0474c056c477f8d6b6cbbb980b14a813829d362d9261"
    sha256 cellar: :any_skip_relocation, sonoma:        "d73fa876ba56773601ad0aba9d459a14bd08f9678a1c1ef412b099b2f10bb11f"
    sha256 cellar: :any_skip_relocation, ventura:       "22ad293dec66d2b02d524e7f2b2f7a41d667af225130a832d26023cad73088a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7aa0e49c8fb1a0af523aba68346a85b97441475d0e415c7d4d22487ef96adf88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caaab41754cacb2f6265623542eae257e1c2dfd5ef0d585632ca1dcad59cfc91"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build
  depends_on "gmp"

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
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
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
