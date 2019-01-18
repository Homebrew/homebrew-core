class Lean < Formula
  desc "Theorem prover"
  homepage "https://leanprover.github.io/"
  url "https://github.com/leanprover/lean/archive/v3.4.2.tar.gz"
  sha256 "ec4488be8473577666f38dec81123d0f7b26476139d3caa2e175a571f6c00d87"
  head "https://github.com/leanprover/lean.git"

  bottle do
    cellar :any
    sha256 "f9b31e72b4a0c314c09af988e21172bcfce644487a2e7f4d0bafb898be3a8ee0" => :mojave
    sha256 "5afcb08796f1e4bf4600006c7b3ebcb76e90f15a14bce73af97f55f1896a4ef1" => :high_sierra
    sha256 "4c25bc5a6233614a706323e9a4bfec26bb83f10d67a96f05272ad2c0fe2c7e71" => :sierra
    sha256 "711ed18ebd939e8db24c1c87cba002fd6e590fbc92e110aae7e78310852343b2" => :el_capitan
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
