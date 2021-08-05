class Lean < Formula
  desc "Theorem prover"
  homepage "https://leanprover-community.github.io/"
  url "https://github.com/leanprover-community/lean/archive/v3.30.0.tar.gz"
  sha256 "402b89ff4d368fd6597dd87c521fd2fe456c6b2b90c99d85f57523661bdd94be"
  license "Apache-2.0"
  head "https://github.com/leanprover-community/lean.git"

  # The Lean 3 repository (https://github.com/leanprover/lean/) is archived
  # and there won't be any new releases. Lean 4 is being developed but is still
  # a work in progress: https://github.com/leanprover/lean4
  livecheck do
    skip "Lean 3 is archived; add a new check once Lean 4 is stable"
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "dce6ff86967540c830fa6aecb39e1dcb3dd54beaa0a524ef373e405dbb6f514a"
    sha256 cellar: :any,                 big_sur:       "a10756134d6e97923dc0425d02a8b1ee0a49b4758f49f27e03282887071cde6f"
    sha256 cellar: :any,                 catalina:      "014297ad90fee979d9e726fc08d13edd2adab94986541cd67172f62f845aaea5"
    sha256 cellar: :any,                 mojave:        "386b72209c9b4fdea4f1ee0a5cded5560bd276e4b9e297c4e4586efbb03c4e74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d866e92baca2a841cec6605bcbe9e6246fb5f90edbc5c5e054a15c3afd6d69a"
  end

  depends_on "cmake" => :build
  depends_on "coreutils"
  depends_on "gmp"
  depends_on "jemalloc"
  depends_on macos: :mojave

  conflicts_with "elan-init", because: "`lean` and `elan-init` install the same binaries"

  def install
    mkdir "src/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"hello.lean").write <<~EOS
      def id' {α : Type} (x : α) : α := x

      inductive tree (α : Type) : Type
      | node : α → list tree → tree

      example (a b : Prop) : a ∧ b -> b ∧ a :=
      begin
          intro h, cases h,
          split, repeat { assumption }
      end
    EOS
    system bin/"lean", testpath/"hello.lean"
    system bin/"leanpkg", "help"
  end
end
