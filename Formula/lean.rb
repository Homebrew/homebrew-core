class Lean < Formula
  desc "Theorem prover"
  homepage "https://leanprover.github.io/"
  url "https://github.com/leanprover/lean/archive/v3.3.0.tar.gz"
  sha256 "d974ec33c6ca4910388b4fc6c59f1bfc81b5f58640ed1b7450042a6ada50ba1d"
  head "https://github.com/leanprover/lean.git"

  bottle do
    cellar :any
    sha256 "6bb7a327d8affe2685a07cb339abf8f49dbf9984b67ce28987d6ae37975470c4" => :high_sierra
    sha256 "8a1979e0ce82b2672100412c3e9a81e89f281128eb820570a429bcada4664db0" => :sierra
    sha256 "866478c27b8a39507fc9afa8aa4793e58e071f81acd45e3e90628a2f95d08e4b" => :el_capitan
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
