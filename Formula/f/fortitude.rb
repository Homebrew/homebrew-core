class Fortitude < Formula
  desc "Fortran linter"
  homepage "https://fortitude.readthedocs.io/en/stable/"
  url "https://github.com/PlasmaFAIR/fortitude/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "a481dddcee5a680bb67ecad745d6378daa1f4166a2e4a7421af1f6a4ef8006c1"
  license "MIT"
  head "https://github.com/PlasmaFAIR/fortitude.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "994bab0e0fd618a49eeeb95500e014fff83538cbe39e2844887964aeaa35bd5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a5261ab43b9f13b89ba6085b78fc782c71d903807e99e34b73b2d6269bb3a81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9207d2491adac6654625b004bf7b2b6b2eb98445ce814d215352201fe6278d8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8296b1ccbad4712c34b78085396fb16d89ac9d9ff075d0d53ae5c53dbae89226"
    sha256 cellar: :any_skip_relocation, sonoma:        "83ea9ee30e9892d3c7c2dd823037d2dbb820155918939ececb459f733c8e04f5"
    sha256 cellar: :any_skip_relocation, ventura:       "ae72fa4a996c6fca4927fa051c4d4d34a946b7a72b4f994fe25ef5a652a077b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "360fcdd5b086ee8815b6e52b96b199fd115b67236ad8ecd47b103a84054216cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb1bafe5a28c4730f556282b779d5318ad2efcd04db555e6ba610e2ff2cf18c3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fortitude")
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
