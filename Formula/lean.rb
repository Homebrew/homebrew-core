class Lean < Formula
  desc "Theorem prover"
  homepage "https://leanprover.github.io/"
  url "https://github.com/leanprover/lean/archive/v3.4.2.tar.gz"
  sha256 "ec4488be8473577666f38dec81123d0f7b26476139d3caa2e175a571f6c00d87"
  head "https://github.com/leanprover/lean.git"

  bottle do
    cellar :any
    sha256 "93067a139b696eec75222a9f14209b1221576281f52238dec585d11f7a39a1c0" => :catalina
    sha256 "a4e42293767b2c39d46ededd68ccdbae0deddc8280a8d5a0004390091e91acd4" => :mojave
    sha256 "31506dc58b1108625510415a551fea963739898ad675d8cb3023af6e3922e109" => :high_sierra
    sha256 "a5df8afdccd0db40f4a9c8184d9197a8a66a47b2c2bbf7451e05976b13274025" => :sierra
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
