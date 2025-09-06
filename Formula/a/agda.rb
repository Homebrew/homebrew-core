class Agda < Formula
  desc "Dependently typed functional programming language"
  homepage "https://wiki.portal.chalmers.se/agda/"
  # agda2hs.cabal specifies BSD-3-Clause but it installs an MIT LICENSE file.
  # Everything else specifies MIT license and installs corresponding file.
  license all_of: ["MIT", "BSD-3-Clause"]

  stable do
    url "https://github.com/agda/agda/archive/refs/tags/v2.8.0.tar.gz"
    sha256 "6950ccc4848ef18c22866a391b3d72f1c59bb87c621391f18d3557d463fe7dbb"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib/archive/refs/tags/v2.3.tar.gz"
      sha256 "407286af16f2b5b8aebe577b3610ae9b40ce296ed3c03c66444b5801c2fa3012"

      # Bugfix in building documentation
      # Should be agda/agda-stdlib commit 628f0a255b36ca96d36e9a83db6e9bdd4f73aa25,
      # but that commit includes a change to the CHANGELOG file that doesn't
      # apply cleanly.
      # Remove on next version bump
      patch :DATA
    end

    resource "cubical" do
      url "https://github.com/agda/cubical/archive/refs/tags/v0.9.tar.gz"
      sha256 "3dde4c1936e8b5583a5adda429de7a6a6e14295d09434591d65ad52c7009cf9a"

      # Bugfix in building documentation
      # Remove on next version bump
      patch do
        url "https://github.com/agda/cubical/commit/294e7960eeb03a3a5f9041e49980b061e4a4a51b.patch?full_index=1"
        sha256 "d845f5e7cfc17a7324d883a20e701e69fe2a3036c6da9b3837c0c6558136e138"
      end
    end

    # TODO: bump version
    resource "categories" do
      # Use git checkout due to `git ls-tree` usage in Makefile
      url "https://github.com/agda/agda-categories.git",
          tag:      "v0.2.0",
          revision: "aee4189dd86889ee14338875ff7f6a81f35379c2"
    end

    resource "agda2hs" do
      url "https://github.com/agda/agda2hs/archive/refs/tags/v1.4.tar.gz"
      sha256 "5f3ac5844de293d40e2909bfff4ad097c844e30f314d2f18a1ed114c3283f818"
    end
  end

  # The regex below is intended to match stable tags like `2.6.3` but not
  # seemingly unstable tags like `2.6.3.20230930`.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*\.\d{1,3})$/i)
  end

  bottle do
    sha256 arm64_sequoia: "6ccb91547fa1089a51f5509ae6adfcf32a9221dfcc6bc0a7c280c1b251311f2a"
    sha256 arm64_sonoma:  "427d2fb8a22bc5929eadb1e855e02b24658b3cda05645dc03fc02ee10f1ecee4"
    sha256 arm64_ventura: "9ab79232aae4d1781b046d4a620faade6047ab1a1512d55fe3fc01ee201951e4"
    sha256 sonoma:        "7249da70860667e11c32532966eb455be22832e87efb318f753b2282f74fee50"
    sha256 ventura:       "9ecfc864ab875692abf9f83092938261c5596f456fa86efafa296025c752f11c"
    sha256 arm64_linux:   "d172a07287def95bfc0245f351a1ef52bc9b7f16b36dfcada31fddc77673c414"
    sha256 x86_64_linux:  "0383a41e66f1487ea96b3d616d54e1fd9c6890be1aa4965be3365429b9d49ba0"
  end

  head do
    url "https://github.com/agda/agda.git", branch: "master"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib.git", branch: "master"
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
  end

  depends_on "cabal-install" => :build
  depends_on "emacs" => :build
  depends_on "ghc"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    agda2hs_build = buildpath/"agda2hs"
    # use pkgshare for write permissions needed to re-generate .agdai when using different options
    agdaprim = pkgshare/"prim"
    stdlib = pkgshare/"stdlib"
    cubicallib = pkgshare/"cubical"
    categorieslib = pkgshare/"categories"
    agda2hs_lib = pkgshare/"agda2hs"

    resource("agda2hs").stage agda2hs_build
    resource("stdlib").stage stdlib
    resource("cubical").stage cubicallib
    resource("categories").stage categorieslib

    # Set up the primitive library and data file directory ahead of time
    mkdir_p agdaprim
    ENV["Agda_datadir"] = agdaprim.to_s

    (buildpath/"cabal.project.local").write <<~HASKELL
      packages: . #{agda2hs_build}
      package Agda
        flags: +optimise-heavily
    HASKELL

    cabal_args = std_cabal_v2_args.map { |s| s.sub "=copy", "=symlink" }
    # Reduce install size by dynamically linking to shared libraries in store-dir
    # TODO: Linux support, related issue https://github.com/haskell/cabal/issues/9784
    cabal_args += %w[--enable-executable-dynamic --enable-shared] if OS.mac?

    # Expose certain packages for building and testing
    exposed_packages = %w[base ieee754 text directory containers]

    system "cabal", "v2-update"
    system "cabal", "--store-dir=#{libexec}", "v2-install", *exposed_packages, "--lib", *cabal_args
    system "cabal", "--store-dir=#{libexec}", "v2-install", ".", agda2hs_build, *cabal_args

    # Write out the primitive library and data files
    system bin/"agda", "--setup"
    system bin/"agda", "--emacs-mode", "compile"

    # Allow build scripts to find stdlib and just built agda binary
    Pathname("#{Dir.home}/.config/agda/libraries").write "#{stdlib}/standard-library.agda-lib"
    ENV.prepend_path "PATH", bin

    # Generate documentation and interface files. We build without extra options
    # so generated interface files work on basic use case. Options like -Werror
    # will need re-generation: https://github.com/agda/agda/issues/5151
    system "make", "-C", stdlib, "listings", "AGDA_OPTIONS="
    system "make", "-C", cubicallib, "listings", "AGDA_FLAGS="
    system "make", "-C", categorieslib, "html", "OTHEROPTS="

    # Clean up references to Homebrew shims and temporary generated files
    rm_r("#{stdlib}/dist-newstyle")

    # Move the agda2hs support libraries into place
    agda2hs_lib.install (agda2hs_build/"lib").subdirs

    # generate interface files for agda2hs libraries
    cd agda2hs_lib/"base" do
      system bin/"agda", "--no-default-libraries",
                         "--build-library"
    end
    cd agda2hs_lib/"containers" do
      system bin/"agda", "--no-default-libraries",
                         "--library-file=./agda2hs-libraries",
                         "--build-library"
      # adapted from upstream at
      # https://github.com/agda/agda2hs/blob/master/lib/containers/generate-haskell.sh
      system bin/"agda2hs", "--no-default-libraries",
                            "--library-file=./agda2hs-libraries",
                            "-o", "./haskell",
                            "./agda/Containers.agda"
    end

    # make the binaries into env scripts so that the primitive files can be picked up automatically
    bin.env_script_all_files(libexec/"bin", Agda_datadir: agdaprim.to_s)

    # write out the example libraries and defaults files for users to copy
    (pkgshare/"example-libraries").write <<~TEXT
      #{opt_pkgshare}/stdlib/standard-library.agda-lib
      #{opt_pkgshare}/stdlib/doc/standard-library-doc.agda-lib
      #{opt_pkgshare}/stdlib/tests/standard-library-tests.agda-lib
      #{opt_pkgshare}/cubical/cubical.agda-lib
      #{opt_pkgshare}/categories/agda-categories.agda-lib
      #{opt_pkgshare}/agda2hs/base/base.agda-lib
      #{opt_pkgshare}/agda2hs/containers/containers.agda-lib
    TEXT
    (pkgshare/"example-defaults").write <<~TEXT
      standard-library
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

    cubicaltest = testpath/"CubicalTest.agda"
    cubicaltest.write <<~AGDA
      {-# OPTIONS --cubical #-}
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
  end
end
__END__
diff --git a/doc/README/Data/Fin/Relation/Unary/Top.agda b/doc/README/Data/Fin/Relation/Unary/Top.agda
index 390a48d58f49a595a3a12e4474e4ef2f122ed1da..181520b87f0f2fca43f62ca7ce9741d8929dd9bb 100644
--- a/doc/README/Data/Fin/Relation/Unary/Top.agda
+++ b/doc/README/Data/Fin/Relation/Unary/Top.agda
@@ -94,7 +94,7 @@ open WF using (Acc; acc)
   induct : ∀ {i} → Acc _>_ i → P i
   induct {i} (acc rec) with view i
   ... | ‵fromℕ = Pₙ
-  ... | ‵inject₁ j = Pᵢ₊₁⇒Pᵢ j (induct (rec _ inject₁[j]+1≤[j+1]))
+  ... | ‵inject₁ j = Pᵢ₊₁⇒Pᵢ j (induct (rec inject₁[j]+1≤[j+1]))
     where
     inject₁[j]+1≤[j+1] : suc (toℕ (inject₁ j)) ≤ toℕ (suc j)
     inject₁[j]+1≤[j+1] = ≤-reflexive (toℕ-inject₁ (suc j))
