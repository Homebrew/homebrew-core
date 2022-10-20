class NuSmv < Formula
  desc "Reimplementation and extension of SMV symbolic model checker"
  homepage "https://nusmv.fbk.eu"
  url "https://nusmv.fbk.eu/distrib/NuSMV-2.6.0.tar.gz"
  sha256 "dba953ed6e69965a68cd4992f9cdac6c449a3d15bf60d200f704d3a02e4bbcbb"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe65bcdedc024ee8cb5c94fcd1cb6487a5ba85bd76e82f3f3d84dfbe18aa19e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4335d0633f214a331bbdf3d060ec0fd574a257ebe1f082025d86cc3a082eac3f"
    sha256 cellar: :any_skip_relocation, monterey:       "078139325d2258530e56211e7d2104dddc48e8640675b68b8c8548b1b8b90149"
    sha256 cellar: :any_skip_relocation, big_sur:        "93b0188158e38160632863ca61c3e6809e2524fc46f93dacbe6d8c07a1693432"
    sha256 cellar: :any_skip_relocation, catalina:       "90dad1b30d80ee7ddba984d6ad2536fff08896e79cf1a26a083a5e9990fc3c43"
    sha256 cellar: :any_skip_relocation, mojave:         "c2cc207758d6f315db1116e0e162be72edc0356312c460cd3359dca8c7de597e"
    sha256 cellar: :any_skip_relocation, high_sierra:    "f2e93143e60b64244fd25958a88480acee332fd4109a6bd356719dc6259efc36"
    sha256 cellar: :any_skip_relocation, sierra:         "64f825eac53c6c16c9b3db4b505d37a6de9f1f3471863b39081b5a98d517fb3e"
  end

  # Requires Python2 to run a build script.
  # https://github.com/Homebrew/homebrew-core/issues/93940
  deprecate! date: "2022-04-23", because: :unsupported

  depends_on "cmake" => :build

  def install
    mkdir "NuSMV/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.smv").write <<~EOS
      MODULE main
      SPEC TRUE = TRUE
    EOS

    output = shell_output("#{bin}/NuSMV test.smv")
    assert_match "specification TRUE = TRUE  is true", output
  end
end
