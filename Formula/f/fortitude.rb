class Fortitude < Formula
  desc "Fortran linter"
  homepage "https://fortitude.readthedocs.io/en/stable/"
  url "https://github.com/PlasmaFAIR/fortitude/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "0b4b3e70b83f35251f9b51bbd06321f99c1978bc09f311b8d2e4c090c603e371"
  license "MIT"
  head "https://github.com/PlasmaFAIR/fortitude.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "232cd119f99c016fa944e0adb12e4ef8d39e670e99088faea46854089cc4d264"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ef277dfe226d974987427553d312405e2e9ba5350c0d21e9c3bc3a963aee4d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76b0ad825f929bab7793c2bdd45046b5a4522740b6a2901aca94094f9aa66f7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "62efc25e568080166966066296b7f30623905602770052c65835743623ee4b61"
    sha256 cellar: :any_skip_relocation, ventura:       "70fb40912641fa23f7bfe4af27410dedfdb61a9d3a693b2d0e7d6994bf90b60a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b65006ff9713bbb87122e5188dcd3e6e7a875d0890f642b73e9570fd930e278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "812f3fcf3f2c5c699192f8d5b0bcdfbefd98336858427ab7f90ff7e3be299acf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "fortitude")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortitude --version")

    (testpath/"test.f90").write <<~FORTRAN
      PROGRAM hello
        WRITE(*,'(A)') 'Hello World!'
      ENDPROGRAM
    FORTRAN

    output = shell_output("#{bin}/fortitude check #{testpath}/test.f90 2>&1", 1)
    assert_match <<~EOS, output
      fortitude: 1 files scanned.
      Number of errors: 2
    EOS
  end
end
