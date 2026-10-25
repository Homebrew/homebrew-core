class Agda < Formula
  desc "Dependently typed functional programming language"
  homepage "https://wiki.portal.chalmers.se/agda/"
  # agda2hs.cabal specifies BSD-3-Clause but it installs an MIT LICENSE file.
  # Everything else specifies MIT license and installs corresponding file.
  license all_of: ["MIT", "BSD-3-Clause"]

  stable do
    url "https://github.com/agda/agda/archive/refs/tags/v2.9.0-rc1.tar.gz"
    sha256 "3845a296404af54d5a146fbd53ff0c002925e5265c46d3615b3cf56422781cb9"
    version "2.9.0"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib/archive/refs/tags/v2.4.tar.gz"
      sha256 "dd0fab4519523d6c08cd9583a4f5eac38ab135a12ccdab1fb164c271075f6747"

      # Build fix for Agda 2.9.0
      # Remove on next version bump
      patch do
        url "https://github.com/agda/agda-stdlib/commit/2ffa8b7d4e8e818717ad643d184f055a4d1b0447.patch?full_index=1"
        sha256 "61ccbd074e73e6c8ab5274632da70055d7cd4e915057738fb10546071e3cd971"
        type :backport
        resolves "https://github.com/agda/agda-stdlib/pull/3115"
      end
    end

    resource "stdlib-classes" do
      url "https://github.com/agda/agda-stdlib-classes/archive/refs/tags/v2.3.tar.gz"
      sha256 "00e59758b932597b4663b6ac7e3e183bfc0a4e9b905c0fb3dc8bb2b6c49cc693"
    end

    resource "stdlib-meta" do
      url "https://github.com/agda/agda-stdlib-meta/archive/refs/tags/v2.3.tar.gz"
      sha256 "9d12d5b4503907115be83e2c2701be29542173384f9a552f0e538e38d9f8e1ba"
    end

    resource "cubical" do
      url "https://github.com/agda/cubical/archive/refs/tags/v0.9.tar.gz"
      sha256 "3dde4c1936e8b5583a5adda429de7a6a6e14295d09434591d65ad52c7009cf9a"

      # Bugfix in building documentation
      # Remove on next version bump
      patch do
        url "https://github.com/agda/cubical/commit/294e7960eeb03a3a5f9041e49980b061e4a4a51b.patch?full_index=1"
        sha256 "d845f5e7cfc17a7324d883a20e701e69fe2a3036c6da9b3837c0c6558136e138"
        type :backport
        resolves "https://github.com/agda/cubical/pull/1241"
      end

      # Build fix for Agda 2.9.0
      # Remove on next version bump
      patch do
        url "https://github.com/agda/cubical/commit/c2d05f7909c2254e2dfa5783b1bc88d99b878b87.patch?full_index=1"
        sha256 "0a896019be8fc2f4ebd1244cfac88a1369c406d3b7aa55bfd81e23f4c9c3c097"
        type :backport
        resolves "https://github.com/agda/cubical/pull/1325"
      end

      # Build fix for Agda 2.9.0
      # Remove on next version bump
      patch do
        url "https://github.com/agda/cubical/commit/3d828afcac588414920565ad22d08d3dcdf02249.patch?full_index=1"
        sha256 "2fedc3118b09f73274ff6e2e770fad8ac4c3a03d635f2f05eed5cac27f645dae"
        type :backport
        resolves "https://github.com/agda/cubical/pull/1329"
      end
    end

    resource "categories" do
      # Use git checkout due to `git ls-tree` usage in Makefile
      url "https://github.com/agda/agda-categories.git",
          tag:      "v0.3.0",
          revision: "02be9337ad5bf0dedae84cefd58b11f25b18855a"

      # Build fix for Agda 2.9.0
      # Remove on next version bump
      patch do
        url "https://github.com/agda/agda-categories/commit/5f52ac8753c468df1f9ed8cb93b7d731d88b2cb9.patch?full_index=1"
        sha256 "302f4979a90f56b2a15a32d92e58ed91b92cd8705b51cc85da5e4a40f1180d39"
        type :backport
        resolves "https://github.com/agda/agda-categories/pull/554"
      end
    end

    resource "agda2hs" do
      url "https://github.com/agda/agda2hs/archive/refs/tags/v1.4.tar.gz"
      sha256 "e3f377b18a4545aea2cd9292f21962e896993be4b470f0b0a7865f3129688c6b"
    end

    resource "agda-language-server" do
      url "https://github.com/agda/agda-language-server/archive/refs/tags/v8.tar.gz"
      sha256 "58c18627786451d43269cde03a062716a05dc9ff1fa74fc82e6f48f449c9e5c9"

      # Bug fix for linkage on macOS
      # Remove on next version bump
      patch do
        url "https://github.com/agda/agda-language-server/commit/0ff4166e375f7e0c3f503d7fea58e14d90fd335b.patch?full_index=1"
        sha256 "3f074b5c556d2838d7de7ec22dc4cc806b6a334c6ace8d7cf43fe4b4ecf87b4d"
        type :backport
        resolves "https://github.com/agda/agda-language-server/issues/30"
      end

      # Build fix for Agda 2.9.0
      # Remove on next version bump
      patch :DATA
    end
  end

  # The regex below is intended to match stable tags like `2.6.3` but not
  # seemingly unstable tags like `2.6.3.20230930`.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*\.\d{1,3}(?:-?[rR]\d{1,2})?)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "87d401edaab575cfaa9e28bd357d5ccadfc7ea7e31acbd1be0be7ad863e3ccea"
    sha256 arm64_tahoe:       "1d163cb056ba37c65662f54668b9bb47a03a31d47aeac950d1daf541188d96f6"
    sha256 arm64_sequoia:     "e8dbe09a5c55af86c8ab97af359672b99b2d68a41aac1eb4118c6753a778b5e5"
    sha256 arm64_linux:       "712c575bd41b3af6111feea653bb96662ee79c521f0efc75f84e51020ada4dab"
    sha256 x86_64_linux:      "9a531c138a9c6cc2c1a856c1018571dac37ad69025836f5742f566d9279ec63e"
  end

  head do
    url "https://github.com/agda/agda.git", branch: "master"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib.git", branch: "master"
    end

    resource "stdlib-classes" do
      url "https://github.com/agda/agda-stdlib-classes.git", branch: "master"
    end

    resource "stdlib-meta" do
      url "https://github.com/agda/agda-stdlib-meta.git", branch: "master"
    end

    resource "cubical" do
      url "https://github.com/agda/cubical.git", branch: "master"
    end

    resource "categories" do
      url "https://github.com/agda/agda-categories.git", branch: "master"
    end

    resource "agda2hs" do
      url "https://github.com/agda/agda2hs.git", branch: "master"
    end

    resource "agda-language-server" do
      url "https://github.com/agda/agda-language-server.git", branch: "master"
    end
  end

  depends_on "cabal-install" => :build
  depends_on "emacs" => :build
  depends_on "hpack" => :build
  depends_on "pkgconf" => :build
  depends_on "ghc"
  depends_on "gmp"
  depends_on "icu4c@78"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    agda2hs_build = buildpath/"agda2hs"
    als = buildpath/"agda-language-server"
    # use pkgshare for write permissions needed to re-generate .agdai when using different options
    agdaprim = pkgshare/"prim"
    stdlib = pkgshare/"stdlib"
    classeslib = pkgshare/"stdlib-classes"
    metalib = pkgshare/"stdlib-meta"
    cubicallib = pkgshare/"cubical"
    categorieslib = pkgshare/"categories"
    agda2hs_lib = pkgshare/"agda2hs"

    resource("agda2hs").stage agda2hs_build
    resource("agda-language-server").stage als
    resource("stdlib").stage stdlib
    resource("stdlib-classes").stage classeslib
    resource("stdlib-meta").stage metalib
    resource("cubical").stage cubicallib
    resource("categories").stage categorieslib

    # Set up the primitive library and data file directory ahead of time
    mkdir_p agdaprim
    ENV["Agda_datadir"] = agdaprim.to_s

    # Make agda2hs build compatible with GHC 9.14
    inreplace agda2hs_build/"agda2hs.cabal",
      "base                 >= 4.13    && < 4.22",
      "base                 >= 4.13    && < 4.23"

    # Make the Agda Emacs mode compatible with Emacs >= 31.1
    inreplace buildpath/"src/data/emacs-mode/agda2-highlight.el", " font-lock-", " 'font-lock-"

    # Create the cabal file for the language server build
    cd als do
      system "hpack"
    end

    # Relative package paths keep Cabal file monitoring inside the build directory.
    (buildpath/"cabal.project").write <<~HASKELL
      packages: . agda2hs agda-language-server
      package Agda
        flags: +optimise-heavily +enable-cluster-counting
      package agda-language-server
        flags: +Agda-2-9-0
    HASKELL

    cabal_args = std_cabal_v2_args.map { |s| s.sub "=copy", "=symlink" }
    # Reduce install size by dynamically linking to shared libraries in store-dir
    # TODO: Linux support, related issue https://github.com/haskell/cabal/issues/9784
    cabal_args += %w[--enable-executable-dynamic --enable-shared] if OS.mac?

    # Expose certain packages for building and testing
    exposed_packages = %w[base ieee754 text directory containers]

    system "cabal", "v2-update"
    system "cabal", "--store-dir=#{libexec}", "v2-install", *exposed_packages, "--lib", *cabal_args
    system "cabal", "--store-dir=#{libexec}", "v2-install", ".", agda2hs_build, als, *cabal_args

    # Write out the primitive library and data files
    system bin/"agda", "--setup"
    system bin/"agda", "--emacs-mode", "compile"

    # Allow build scripts to find stdlib (with classes) and just built agda binary
    Pathname("#{Dir.home}/.config/agda/libraries").write <<~AGDALIB
      #{stdlib}/standard-library.agda-lib
      #{classeslib}/agda-stdlib-classes.agda-lib
    AGDALIB
    ENV.prepend_path "PATH", bin

    # work around issue related to find command on older macOS
    inreplace cubicallib/"generate-everything.sh", "find Cubical/ ", "find Cubical "

    # allow categories library to work with newer stdlib
    inreplace categorieslib/"agda-categories.agda-lib", "standard-library-2.3", "standard-library"
    # allow stdlib-meta library to work with newer stdlib
    inreplace metalib/"agda-stdlib-meta.agda-lib", "standard-library-2.3", "standard-library"

    # Generate documentation and interface files. We build without extra options
    # so generated interface files work on basic use case. Options like -Werror
    # will need re-generation: https://github.com/agda/agda/issues/5151
    system "make", "-C", stdlib, "listings", "AGDA_OPTIONS=-j#{ENV.make_jobs}"
    system "make", "-C", cubicallib, "listings", "AGDA_FLAGS=-j#{ENV.make_jobs}"
    system "make", "-C", categorieslib, "html", "OTHEROPTS=-j#{ENV.make_jobs}"

    # More manually built documentation and interfaces
    cd classeslib do
      system "agda", "-j#{ENV.make_jobs}", "--html", "standard-library-classes.agda"
    end
    cd metalib do
      system "agda", "-j#{ENV.make_jobs}", "--html", "standard-library-meta.agda"
    end

    # Clean up references to Homebrew shims and temporary generated files
    rm_r("#{stdlib}/dist-newstyle")

    # Move the agda2hs support libraries into place
    agda2hs_lib.install (agda2hs_build/"lib").subdirs

    # generate interface files for agda2hs libraries
    cd agda2hs_lib/"base" do
      system bin/"agda", "-j#{ENV.make_jobs}", "--no-default-libraries", "--build-library"
    end
    cd agda2hs_lib/"containers" do
      system bin/"agda", "-j#{ENV.make_jobs}", "--no-default-libraries",
                         "--library-file=./agda2hs-libraries", "--build-library"
      # adapted from upstream at
      # https://github.com/agda/agda2hs/blob/master/lib/containers/generate-haskell.sh
      system bin/"agda2hs", "--no-default-libraries",
                            "--library-file=./agda2hs-libraries",
                            "-o", "./haskell",
                            "./agda/Containers.agda"
    end

    # make the binaries into env scripts so that the primitive files can be picked up automatically
    # cannot use env_script_all_files for this because these are symlinks
    bin.each_child do |f|
      real_f = f.realpath
      f.delete
      f.write_env_script(real_f, Agda_datadir: agdaprim.to_s)
    end

    # write out the example libraries and defaults files for users to copy
    (pkgshare/"example-libraries").write <<~TEXT
      #{opt_pkgshare}/stdlib/standard-library.agda-lib
      #{opt_pkgshare}/stdlib-classes/agda-stdlib-classes.agda-lib
      #{opt_pkgshare}/stdlib-meta/agda-stdlib-meta.agda-lib
      #{opt_pkgshare}/stdlib/doc/standard-library-doc.agda-lib
      #{opt_pkgshare}/cubical/cubical.agda-lib
      #{opt_pkgshare}/categories/agda-categories.agda-lib
      #{opt_pkgshare}/agda2hs/base/base.agda-lib
      #{opt_pkgshare}/agda2hs/containers/containers.agda-lib
    TEXT
    (pkgshare/"example-defaults").write <<~TEXT
      standard-library
      standard-library-classes
      standard-library-meta
      cubical
      agda-categories
      agda2hs-base
      agda2hs-containers
    TEXT
  end

  def caveats
    <<~EOS
      To use the installed Agda libraries, execute the following commands:

          mkdir -p $HOME/.config/agda
          cp #{opt_pkgshare}/example-libraries $HOME/.config/agda/libraries
          cp #{opt_pkgshare}/example-defaults $HOME/.config/agda/defaults

      You can then inspect the copied files and customize them as needed.
      If you have upgraded your Agda installation from a previous version, you may need to redo this.
    EOS
  end

  test do
    ENV.prepend_path "PATH", formula_opt_bin("ghc")

    Pathname("#{Dir.home}/.config/agda").install_symlink opt_pkgshare/"example-libraries" => "libraries"
    Pathname("#{Dir.home}/.config/agda").install_symlink opt_pkgshare/"example-defaults" => "defaults"

    simpletest = testpath/"SimpleTest.agda"
    simpletest.write <<~AGDA
      {-# OPTIONS --safe --cubical-compatible #-}
      module SimpleTest where

      infix 4 _≡_
      data _≡_ {A : Set} (x : A) : A → Set where
        refl : x ≡ x

      cong : ∀ {A B : Set} (f : A → B) {x y} → x ≡ y → f x ≡ f y
      cong f refl = refl
    AGDA

    stdlibtest = testpath/"StdlibTest.agda"
    stdlibtest.write <<~AGDA
      module StdlibTest where

      open import Data.Nat
      open import Relation.Binary.PropositionalEquality

      +-assoc : ∀ m n o → (m + n) + o ≡ m + (n + o)
      +-assoc zero    _ _ = refl
      +-assoc (suc m) n o = cong suc (+-assoc m n o)
    AGDA

    stdlibclassestest = testpath/"StdlibClassesTest.agda"
    stdlibclassestest.write <<~AGDA
      module StdlibClassesTest where

      open import Data.Nat using (ℕ)
      open import Relation.Binary.PropositionalEquality using (_≡_; refl)
      open import Class.HasAdd

      +-0-annihilate : (m : ℕ) → (0 + m) ≡ m
      +-0-annihilate _ = refl
    AGDA

    stdlibmetatest = testpath/"StdlibMetaTest.agda"
    stdlibmetatest.write <<~AGDA
      module StdlibMetaTest where

      open import Relation.Binary.PropositionalEquality using (_≡_; refl)
      open import Reflection.Syntax using (`∅; Pattern)

      `∅-expand : `∅ ≡ Pattern.absurd 0
      `∅-expand = refl
    AGDA

    cubicaltest = testpath/"CubicalTest.agda"
    cubicaltest.write <<~AGDA
      {-# OPTIONS --cubical --guardedness #-}
      module CubicalTest where

      open import Cubical.Foundations.Prelude
      open import Cubical.Foundations.Isomorphism
      open import Cubical.Foundations.Univalence
      open import Cubical.Data.Int

      suc-equiv : ℤ ≡ ℤ
      suc-equiv = ua (isoToEquiv (iso sucℤ predℤ sucPred predSuc))
    AGDA

    categoriestest = testpath/"CategoriesTest.agda"
    categoriestest.write <<~AGDA
      module CategoriesTest where

      open import Level using (zero)
      open import Data.Empty
      open import Data.Quiver
      open Quiver

      empty-quiver : Quiver zero zero zero
      Obj empty-quiver = ⊥
      _⇒_ empty-quiver ()
      _≈_ empty-quiver {()}
      equiv empty-quiver {()}
    AGDA

    iotest = testpath/"IOTest.agda"
    iotest.write <<~AGDA
      module IOTest where

      open import Agda.Builtin.IO
      open import Agda.Builtin.Unit

      postulate
        return : ∀ {A : Set} → A → IO A

      {-# COMPILE GHC return = \\_ -> return #-}

      main : _
      main = return tt
    AGDA

    agda2hstest = testpath/"Agda2HsTest.agda"
    agda2hstest.write <<~AGDA
      {-# OPTIONS --erasure #-}
      module Agda2HsTest where
      open import Haskell.Prelude

      _≤_ : {{Ord a}} → a → a → Set
      x ≤ y = (x <= y) ≡ True

      data BST (a : Set) {{@0 _ : Ord a}} (@0 lower upper : a) : Set where
        Leaf : (@0 pf : lower ≤ upper) → BST a lower upper
        Node : (x : a) (l : BST a lower x) (r : BST a x upper) → BST a lower upper

      {-# COMPILE AGDA2HS BST #-}
    AGDA

    agda2hsout = testpath/"Agda2HsTest.hs"
    agda2hsexpect = <<~HASKELL
      module Agda2HsTest where

      data BST a = Leaf
                 | Node a (BST a) (BST a)

    HASKELL

    # typecheck a simple module
    system bin/"agda", simpletest

    # typecheck a module that uses the standard library
    system bin/"agda", stdlibtest

    # typecheck a module that uses the standard-classes library
    system bin/"agda", stdlibclassestest

    # typecheck a module that uses the standard-meta library
    system bin/"agda", stdlibmetatest

    # typecheck a module that uses the cubical library
    system bin/"agda", cubicaltest

    # typecheck a module that uses the categories library
    system bin/"agda", categoriestest

    # compile a simple module using the JS backend
    system bin/"agda", "--js", simpletest

    # test the GHC backend; compile and run a simple program
    system bin/"agda", "--compile", iotest
    assert_empty shell_output(testpath/"IOTest")

    # translate a simple file via agda2hs
    system bin/"agda2hs", "--out-dir=#{testpath}", agda2hstest
    assert_equal agda2hsexpect, agda2hsout.read

    assert_equal "Agda v#{version.major_minor_patch} Language Server v#{resource("agda-language-server").version}",
                 shell_output("#{bin}/als -V").strip
  end
end
__END__
diff --git a/package.yaml b/package.yaml
index 4b3fcc78cff47cf6e4fa11a701899c20fd1e5eb2..45010eefad075369e9ccc9ae32c2da10efb34d88 100644
--- a/package.yaml
+++ b/package.yaml
@@ -37,6 +37,10 @@ flags:
     description: Embed Agda-2.8.0
     manual: true
     default: false
+  Agda-2-9-0:
+    description: Embed Agda-2.9.0
+    manual: true
+    default: false
   reactor:
     description: Build as a WASI reactor module
     manual: true
@@ -51,6 +55,9 @@ when:
 - condition: "flag(Agda-2-8-0)"
   dependencies:
     - Agda == 2.8.0
+- condition: "flag(Agda-2-9-0)"
+  dependencies:
+    - Agda == 2.9.0
 - condition: "arch(wasm32)"
   then:
     dependencies:
