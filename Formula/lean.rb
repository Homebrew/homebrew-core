class Lean < Formula
  desc "Theorem prover"
  homepage "https://leanprover-community.github.io/"
  url "https://github.com/leanprover-community/lean/archive/v3.27.0.tar.gz"
  sha256 "b6e453f44a5a353d7b7ad807ba13f87735ee51c913e2aff1113fc35dfe8dc214"
  license "Apache-2.0"
  head "https://github.com/leanprover-community/lean.git"

  # The Lean 3 repository (https://github.com/leanprover/lean/) is archived
  # and there won't be any new releases. Lean 4 is being developed but is still
  # a work in progress: https://github.com/leanprover/lean4
  livecheck do
    skip "Lean 3 is archived; add a new check once Lean 4 is stable"
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "54bf309b9271ff9f2f4b60945fe6348dfe517d6ac61670fc2ba1e1bbbe48bded"
    sha256 cellar: :any, big_sur:       "69220ca1e33cba1e97e69c49c8fef33a44cec6b51bc1d5c8fab24266f05fa98a"
    sha256 cellar: :any, catalina:      "7061fcd438716294d81532240eca7ca206a87198d3715d6227b0ce91a2182f58"
    sha256 cellar: :any, mojave:        "6220b1f134ce7fe7376dd8076f28619eaf1fd57d45f8e316022e6d9275a7300f"
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
