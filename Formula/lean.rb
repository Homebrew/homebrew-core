class Lean < Formula
  desc "Theorem prover"
  homepage "https://leanprover.github.io/"
  url "https://github.com/leanprover/lean/archive/v3.3.0.tar.gz"
  sha256 "d974ec33c6ca4910388b4fc6c59f1bfc81b5f58640ed1b7450042a6ada50ba1d"
  head "https://github.com/leanprover/lean.git"

  bottle do
    cellar :any
    sha256 "f960928337fdac1fda7d3ee4e20167d73fbb87a05c09bdfc0a626bbae6031233" => :sierra
    sha256 "ec63932b9dc5d768c6bb2a647d4f7f491a774e38af6b9019cab68220b46fd657" => :el_capitan
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
    (testpath/"hello.lean").write <<-EOS.undent
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
