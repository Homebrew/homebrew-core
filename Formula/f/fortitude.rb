class Fortitude < Formula
  desc "Fortran linter"
  homepage "https://fortitude.readthedocs.io/en/stable/"
  url "https://github.com/PlasmaFAIR/fortitude/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "54a9a12f0b0f85f1448c75d4204b9eb5d2c3ef2095abb364716cd884b65e553b"
  license "MIT"
  head "https://github.com/PlasmaFAIR/fortitude.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89d4acffa99ced65d80f70a7c7ddc58c6cab76ab440d8d8e620a7431457e3b1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "260cf38dc2085196fa0d76d360773be6dd8a1e77ef182712f96a39562c2b8874"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04658dee8414bbc8ead8dce23fb890d4e1d7327a8c378737c40fdbeaaac99969"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b76d843e9631b2fa96221be8bb8ee40ec5c0f4b40c9dcbd3f9959581fc4391d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "decfa0dbed1dbd9ffa8ae2addd567851606cadfb447c882e03b34d1ab4cd8d5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b82d60defb00467475946211ccf32b8336fe327add6ea7714f76eda3b86efb93"
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
