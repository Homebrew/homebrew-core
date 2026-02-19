class Minisat < Formula
  desc "Minimalistic and high-performance SAT solver"
  homepage "https://github.com/stp/minisat"
  url "https://github.com/stp/minisat/archive/refs/tags/releases/2.2.1.tar.gz"
  sha256 "432985833596653fcd698ab439588471cc0f2437617d0df2bb191a0252ba423d"
  license "MIT"
  head "https://github.com/stp/minisat.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "cf6593a34e4fccf6f0e21cd5a5ff25f1228a88bfa865a2a11d87e0a106186a7c"
    sha256 cellar: :any,                 arm64_sequoia: "c99b867058712c4d612c88a4994b087b44d6cea68e01ce30b7af6153609a27e9"
    sha256 cellar: :any,                 arm64_sonoma:  "da140f3fdbd9218b87aa76edc4ca27e630eb64e1c9f88c9766e66889e01259aa"
    sha256 cellar: :any,                 sonoma:        "8b4162944a00007011efc0b60bc3938c0f54b25526121cc1700bf108e673b287"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2a9974eb7be498a0222d84b7b0f82b9fe56c1c41b5437612534219a0d1bf71f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "498f58fa3f510fd9d3381319c866db4a789ab7bbafbf230e635e2a47424ed6c5"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    "-DSTATIC_BINARIES=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cnf").write <<~EOS
      p cnf 5 3
      1 -5 4 0
      -1 5 3 4 0
      -3 -4 0
    EOS

    assert_match "SATISFIABLE", shell_output("#{bin}/minisat test.cnf 2>&1", 10)
  end
end
