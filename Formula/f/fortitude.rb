class Fortitude < Formula
  desc "Fortran linter"
  homepage "https://fortitude.readthedocs.io/en/stable/"
  url "https://github.com/PlasmaFAIR/fortitude/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "caf5148a20a433e8031fbb875465648ca7a918fd975dd704249e41d7a98bafe6"
  license "MIT"
  head "https://github.com/PlasmaFAIR/fortitude.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed2b0286e104580fbf915dd75496887b73dfbc88655b8e2e5f0821f8cacaf22c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8483c2d3e04ac4b51a5b93bc240e2d705787c3124cb72a51ba3c06083728bbf4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd5779fad276c55e617f17b25eb9f65f373065904f9ff6e1449d667c4a066c21"
    sha256 cellar: :any_skip_relocation, sonoma:        "61ecad6849848b886b9f329ef9181698353451e449d0b1fb55eca8df12fae2fe"
    sha256 cellar: :any_skip_relocation, ventura:       "c8d4eb7505ef1419e13bea9d8ba4545da5cf77623d592dccedb18783abb041c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45f26b0cce1726051a7e9190bcab48c032aca7c26536e97f98751ca6cdf37221"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ef4e870c67cbba08a4e9a8a913521a2280f832adcb538e48937404d1b804a3e"
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
