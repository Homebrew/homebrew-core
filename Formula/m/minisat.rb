class Minisat < Formula
  desc "Minimalistic and high-performance SAT solver"
  homepage "https://github.com/stp/minisat"
  url "https://github.com/stp/minisat/archive/refs/tags/releases/2.2.1.tar.gz"
  sha256 "432985833596653fcd698ab439588471cc0f2437617d0df2bb191a0252ba423d"
  license "MIT"
  head "https://github.com/stp/minisat.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "be98d2db67c95a2f1621123cf0310ab38afecfb478407a0d43f0d90fff34ea25"
    sha256 cellar: :any,                 arm64_sequoia:  "67c3c4650f6e2e5c65d53d7d2681783cda655b3eb9915f79debdbaf77c8ddcf0"
    sha256 cellar: :any,                 arm64_sonoma:   "956661daa83980e03eecb0b94a3acba68ce6a8bf4a122b286c94c9aeed708db9"
    sha256 cellar: :any,                 arm64_ventura:  "518ea1441facc4926c3edddf1fd5e6bf4d2db6460f10d4c4d4ef6c9fd69dcd3d"
    sha256 cellar: :any,                 arm64_monterey: "22895418f1f5e0d2a1efb9cc700f40bdb29e9809423f0c7949eeaacbbbf7b4f3"
    sha256 cellar: :any,                 arm64_big_sur:  "b802117d6cc0fa96bedac9eaa086908687ad87c7a368558e47c2417d3d2b7146"
    sha256 cellar: :any,                 sonoma:         "1f8b90a6d6db3e00b7d74587345abdeeb472a2b423f2a940ef1b487e86e410cf"
    sha256 cellar: :any,                 ventura:        "491bdcc2b593d154333f27413de300da1ef3112c12e950906d49bc50de9aada8"
    sha256 cellar: :any,                 monterey:       "5b028ad6aa66e082709083453b17d150eee4cb2a134b8cccd8c62567928b5859"
    sha256 cellar: :any,                 big_sur:        "ecc424ea3cde4f1a8d7056802d384ce1ab9823393301cac432dc26260685437a"
    sha256 cellar: :any,                 catalina:       "0940a0cb0c4c4d6130d1eb7aa698561d6b01904044ee57731ad2c12092e30e46"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "63183ba50129d6699c3df8ede63fa932b1daa7c0765fcca11a8a6ba7e245a029"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1277996ab9a57f7c617501f9b386c2bb18ac90e00293738c12222dd89d90a979"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

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
