class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.6.3.tar.gz"
  sha256 "740884d4eb8e7acf366efaad82efa0ca46dc4342afa5a6ecc1d749fcc4f96dd4"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "43d87079948f0fafc359731844dc494b9d6727cb20a2d2d9bed8d0ed3d101cab"
    sha256 cellar: :any,                 arm64_big_sur:  "fe444844c4a9b585f70a82cb93106f956c6e69392ac8a70b8e3aa8f09f214891"
    sha256 cellar: :any,                 monterey:       "6a2b15c70e6e42f7a6e206971a91e6b9c7193aee0df57d9c0d01363f93e64b36"
    sha256 cellar: :any,                 big_sur:        "a51b5950cc114e1ebafe1a5ab7a5a8eb401e3023c4f7f8746f0adadf6e95f778"
    sha256 cellar: :any,                 catalina:       "ca44b073b683adb8dfc65072b158658ec82aca056b4a27ac3afd321e95b696a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4d491eb72caaced07731e10f3dea5deebbd68031596fa13755279377b3433b3"
  end

  depends_on "cmake" => :build
  depends_on "cbc"
  depends_on "gecode"

  on_linux do
    depends_on "gcc"
  end

  # Workaround for https://github.com/MiniZinc/libminizinc/issues/546 by undoing commit
  # 894d2d97b5d7c9a24a1b87d71f4c27f9e6a5f0e7, as suggested by a comment there.  Remove
  # this patch when upstream resolves that issue.
  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    (testpath/"satisfy.mzn").write <<~EOS
      array[1..2] of var bool: x;
      constraint x[1] xor x[2];
      solve satisfy;
    EOS
    assert_match "----------", shell_output("#{bin}/minizinc --solver gecode_presolver satisfy.mzn").strip

    (testpath/"optimise.mzn").write <<~EOS
      array[1..2] of var 1..3: x;
      constraint x[1] < x[2];
      solve maximize sum(x);
    EOS
    assert_match "==========", shell_output("#{bin}/minizinc --solver cbc optimise.mzn").strip
  end
end
