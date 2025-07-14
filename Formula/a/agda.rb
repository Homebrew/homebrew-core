class Agda < Formula
  desc "Dependently typed functional programming language"
  homepage "https://wiki.portal.chalmers.se/agda/"
  # agda2hs.cabal specifies BSD-3-Clause but it installs an MIT LICENSE file.
  # Everything else specifies MIT license and installs corresponding file.
  license all_of: ["MIT", "BSD-3-Clause"]
  revision 2

  stable do
    url "https://github.com/agda/agda/archive/refs/tags/v2.7.0.1.tar.gz"
    sha256 "4a2c0a76c55368e1b70b157b3d35a82e073a0df8f587efa1e9aa8be3f89235be"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib/archive/refs/tags/v2.2.tar.gz"
      sha256 "588f94af7fedd5aa1a6a1f0afdfb602d3e4615c7a17e6a0ae9dff326583b7a12"

      # Backport support for building with GHC 9.12
      patch do
        url "https://github.com/agda/agda-stdlib/commit/a78700653de116b1043ce5d80bbe99482a705ecc.patch?full_index=1"
        sha256 "547af4793368a7b37d7b707cc25d0b87bab674233ed69d38d4d685c28e574a58"
      end
    end

    resource "cubical" do
      url "https://github.com/agda/cubical/archive/refs/tags/v0.8.tar.gz"
      sha256 "27b22f2ed981d608f3cbf5d132e9016510c859435b5ce46adc3b76078c136275"
    end

    resource "categories" do
      # Use git checkout due to `git ls-tree` usage in Makefile
      url "https://github.com/agda/agda-categories.git",
          tag:      "v0.2.0",
          revision: "aee4189dd86889ee14338875ff7f6a81f35379c2"

      # Backport support for stdlib 2.1
      patch do
        url "https://github.com/agda/agda-categories/commit/ac0d9d27a402305f6774a6343f7a21a229822168.patch?full_index=1"
        sha256 "50dc97c97898c825dd4c85fffc8452dc3e61a7871aa907d65b1711e5642c05fc"
      end
    end

    resource "agda2hs" do
      url "https://github.com/agda/agda2hs/archive/refs/tags/v1.3.tar.gz"
      sha256 "0e2c11eae0af459d4c78c24efadb9a4725d12c951f9d94da4adda5a0bcb1b6f6"
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
    agda2hs = buildpath/"agda2hs"
    agdalib = pkgshare # for write permissions needed to re-generate .agdai when using different options
    cubicallib = agdalib/"cubical"
    categorieslib = agdalib/"categories"

    # Add a backwards compatibility symlink. Can consider removing in a future release
    lib.install_symlink pkgshare

    resource("agda2hs").stage agda2hs
    resource("stdlib").stage agdalib
    resource("cubical").stage cubicallib
    resource("categories").stage categorieslib

    # Remove strict stdlib version check in categories
    inreplace categorieslib/"agda-categories.agda-lib", /(standard-library)-2\.1$/, "\\1", audit_result: build.stable?

    (buildpath/"cabal.project.local").write <<~HASKELL
      packages: . #{agda2hs}
      package Agda
        flags: +optimise-heavily
      -- Workaround for GHC 9.12 until official supported, https://github.com/agda/agda/issues/7574
      allow-newer: Agda:base, agda2hs:base, agda2hs:filepath
    HASKELL

    cabal_args = std_cabal_v2_args.map { |s| s.sub "=copy", "=symlink" }
    # Reduce install size by dynamically linking to shared libraries in store-dir
    # TODO: Linux support, related issue https://github.com/haskell/cabal/issues/9784
    cabal_args += %w[--enable-executable-dynamic --enable-shared] if OS.mac?

    # Expose certain packages for building and testing
    exposed_packages = %w[base ieee754 text directory]

    system "cabal", "v2-update"
    system "cabal", "--store-dir=#{libexec}", "v2-install", *exposed_packages, "--lib", *cabal_args
    system "cabal", "--store-dir=#{libexec}", "v2-install", ".", agda2hs, *cabal_args

    # Allow build scripts to find stdlib and just built agda binary
    Pathname("#{Dir.home}/.config/agda/libraries").write "#{agdalib}/standard-library.agda-lib"
    ENV.prepend_path "PATH", bin

    # Generate documentation and interface files. We build without extra options
    # so generated interface files work on basic use case. Options like -Werror
    # will need re-generation: https://github.com/agda/agda/issues/5151
    system "make", "-C", agdalib, "listings", "AGDA_OPTIONS="
    # We need to force order between these next two lines, so they can't be combined.
    system "make", "-C", cubicallib, "gen-everythings", "AGDA_FLAGS="
    system "make", "-C", cubicallib, "listings", "AGDA_FLAGS="
    system "make", "-C", categorieslib, "html", "OTHEROPTS="

    # Clean up references to Homebrew shims and temporary generated files
    rm_r("#{agdalib}/dist-newstyle")

    # Move the agda2hs support library into place
    (agdalib/"agda2hs").install agda2hs/"lib", agda2hs/"agda2hs.agda-lib"

    # Workaround to generate interface files for agda2hs based on
    # https://github.com/agda/agda2hs/blob/master/nix/default.nix#L12-L16
    agda2hs_imports = Dir.glob("**/*.agda", base: agdalib/"agda2hs/lib").map do |path|
      "import #{path.delete_suffix(".agda").tr("/", ".")}"
    end
    (agdalib/"agda2hs/Everything.agda").write <<~AGDA
      {-# OPTIONS --sized-types #-}
      module Everything where
      #{agda2hs_imports.join("\n")}
    AGDA
    cd agdalib/"agda2hs" do
      system bin/"agda", "--include-path=.", "Everything.agda"
    end

    # write out the example libraries and defaults files for users to copy
    (agdalib/"example-libraries").write <<~TEXT
      #{opt_pkgshare}/standard-library.agda-lib
      #{opt_pkgshare}/doc/standard-library-doc.agda-lib
      #{opt_pkgshare}/tests/standard-library-tests.agda-lib
      #{opt_pkgshare}/cubical/cubical.agda-lib
      #{opt_pkgshare}/categories/agda-categories.agda-lib
      #{opt_pkgshare}/agda2hs/agda2hs.agda-lib
    TEXT
    (agdalib/"example-defaults").write <<~TEXT
      standard-library
      cubical
      agda-categories
      agda2hs
    TEXT
  end

  def caveats
    <<~EOS
      To use the installed Agda libraries, execute the following commands:

          mkdir -p $HOME/.config/agda
          cp #{opt_pkgshare}/example-libraries $HOME/.config/agda/libraries
          cp #{opt_pkgshare}/example-defaults $HOME/.config/agda/defaults

      You can then inspect the copied files and customize them as needed.
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
