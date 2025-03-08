class Fortitude < Formula
  desc "Fortran linter"
  homepage "https://fortitude.readthedocs.io/en/stable/"
  url "https://github.com/PlasmaFAIR/fortitude/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "b350901db0536d73ff9b5ebcf1ea58ff7fbf547bd593d2955f5dc3363c0bb736"
  license "MIT"
  head "https://github.com/PlasmaFAIR/fortitude.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19b721f0e824d2511c7370fb0174987edb1bcbaa6f2778c85227cb6a2b52ac93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "710b320d33ba1c899399c41650dbcddbb5434efc834779482a70882472a2f68d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e85eb4ba0de08cf9a3df7602f7b3a1a48272069b3aec841d4cd8196634bf3fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfc9e942eaa84ae4695deb64d21c3b01275904a063a2f3422fce331556bc43a0"
    sha256 cellar: :any_skip_relocation, ventura:       "9a66b0633c66ba3ffe0833f30a4725d532172c1d95b278b66c0dab7a862018a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbb2ffbc711b890794584f54da14622c87242f1ee34c82285e33cef2bec2371b"
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
