class Lean < Formula
  desc "Theorem prover"
  homepage "https://leanprover-community.github.io/"
  url "https://github.com/leanprover-community/lean/archive/v3.20.0.tar.gz"
  sha256 "2fdd49ec17e0706346df7c3f013d634e03b2fdcbce341ad04d126e43af31f5c1"
  license "Apache-2.0"
  head "https://github.com/leanprover-community/lean.git"

  # The Lean 3 repository (https://github.com/leanprover/lean/) is archived
  # and there won't be any new releases. Lean 4 is being developed but is still
  # a work in progress: https://github.com/leanprover/lean4
  livecheck do
    skip "Lean 3 is archived; add a new check once Lean 4 is stable"
  end

  bottle do
    cellar :any
    sha256 "60bf9be856f7c4158d18717387bd9a74e1e8036fb4ecdb285b3d410e82fec907" => :catalina
    sha256 "a1cee5b0d39bc214d16ad925c4f5fb70c4edba84da64d4cc0f288233f4b032c8" => :mojave
    sha256 "4efbb7149a7a7f8b85a1c1e8e48e561757b0cf3849b55d31795d30d372ac7a08" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "gmp"
  depends_on "jemalloc"

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
    system "#{bin}/lean", testpath/"hello.lean"
  end
end
