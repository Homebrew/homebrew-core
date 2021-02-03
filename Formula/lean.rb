class Lean < Formula
  desc "Theorem prover"
  homepage "https://leanprover-community.github.io/"
  url "https://github.com/leanprover-community/lean/archive/v3.23.0.tar.gz"
  sha256 "f77831bf3f31cbc4b4dbe44e1b84252624d138045ddb03d3575db8998e71f540"
  license "Apache-2.0"
  head "https://github.com/leanprover-community/lean.git"

  # The Lean 3 repository (https://github.com/leanprover/lean/) is archived
  # and there won't be any new releases. Lean 4 is being developed but is still
  # a work in progress: https://github.com/leanprover/lean4
  livecheck do
    skip "Lean 3 is archived; add a new check once Lean 4 is stable"
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d3b7ae42577682c4d6ac355017eef314203a8a6351200194a95d9b8c12c7f246"
    sha256 cellar: :any, big_sur:       "d1e11b32de65b73b9c83b938f6a24fb5d2663cc59bab361aacccce9b4cd93910"
    sha256 cellar: :any, catalina:      "438c40c670dde56863fcb935ebfa8fc9e51d47920464a9d61aef2f44538fbfa5"
    sha256 cellar: :any, mojave:        "5a963186f2c97e72a086e8f8283469a2d601789fe5598a3d5afb1402f1593ed0"
  end

  depends_on "cmake" => :build
  depends_on "gmp"
  depends_on "jemalloc"
  depends_on macos: :mojave

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
