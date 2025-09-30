class Boolector < Formula
  desc "SMT solver for fixed-size bit-vectors"
  homepage "https://boolector.github.io/"
  url "https://github.com/Boolector/boolector/archive/refs/tags/3.2.4.tar.gz"
  sha256 "249c6dbf4e52ea6e8df1ddf7965d47f5c30f2c14905dce9b8f411756b05878bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c36e9fe92bb625ab45e83a8b889a4f29264b4a6dca0b5da3e72c133724b6ddd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb34a8aa518c75108be45137f5f72401f2a429d5c2aa5485e4addf5f9b7e2397"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1cc2c76b073b53af089a7f14191ffaf3d2f5cc72946ad10456e56b4c05c24cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59043051dc8c304152d395edc3d3460af08a95922fbc0bb7014a0041be9813aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a4617f2272b60e1abed3faa99242423bdae8d761d508abe457b68487f91a030"
    sha256 cellar: :any_skip_relocation, ventura:        "9c19e47efd028a1a3104a53a1102d30ebc239828b5756461e2a7df222c1ee98d"
    sha256 cellar: :any_skip_relocation, monterey:       "7b93dcb7a6974662f62d5bd7b24138117d80d474ca82c3eca2ba42d138040631"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d6312b85c8f97aafbe24c940186b4fb2e12990ca54e93fe5edf29401b7966081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4745395152455d49e3833ee69624a437e36fba98caf9d1d57f0c168d3e9034ca"
  end

  deprecate! date: "2024-08-24", because: :repo_archived
  disable! date: "2025-08-24", because: :repo_archived

  depends_on "cmake" => :build

  # Use commit hash from `contrib/setup-lingeling.sh`
  resource "lingeling" do
    url "https://github.com/arminbiere/lingeling/archive/7d5db72420b95ab356c98ca7f7a4681ed2c59c70.tar.gz"
    sha256 "cf04c8f5706c14f00dd66e4db529c48513a450cc0f195242d8d0762b415f4427"
  end

  # Use commit has from `contrib/setup-btor2tools.sh`
  resource "btor2tools" do
    url "https://github.com/boolector/btor2tools/archive/037f1fa88fb439dca6f648ad48a3463256d69d8b.tar.gz"
    sha256 "d6a5836b9e26719c3b7fe1711d93d86ca4720dc9d4bac11d1fc006fa0a140965"
  end

  def install
    deps_dir = buildpath/"deps/install"

    resource("lingeling").stage do
      system "./configure.sh", "-fPIC"
      system "make"
      (deps_dir/"lib").install "liblgl.a"
      (deps_dir/"include").install "lglib.h"
    end

    resource("btor2tools").stage do
      system "./configure.sh", 'CFLAGS="-fPIC"', "--static"
      cd "build" do
        system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF" if OS.mac?
        system "make"
      end
      (deps_dir/"lib").install "build/lib/libbtor2parser.a"
      (deps_dir/"include/btor2parser").install "src/btor2parser/btor2parser.h"
    end

    args = %W[
      -DBtor2Tools_INCLUDE_DIR=#{deps_dir}/include/btor2parser
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.btor").write <<~EOS
      (set-logic BV)
      (declare-fun x () (_ BitVec 4))
      (declare-fun y () (_ BitVec 4))
      (assert (= (bvadd x y) (_ bv6 4)))
      (check-sat)
      (get-value (x y))
    EOS
    assert_match "sat", shell_output("#{bin}/boolector test.btor 2>/dev/null", 1)
  end
end
