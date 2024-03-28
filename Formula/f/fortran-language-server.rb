class FortranLanguageServer < Formula
  include Language::Python::Virtualenv

  desc "Language Server for Fortran"
  homepage "https://github.com/hansec/fortran-language-server"
  url "https://files.pythonhosted.org/packages/72/46/eb2c733e920a33409906aa145bde93b015f7f77c9bb8bdf65faa8c823998/fortran-language-server-1.12.0.tar.gz"
  sha256 "ec3921ef23d7e2b50b9337c9171838ed8c6b09ac6e1e4fa4dd33883474bd4f90"
  license "MIT"
  head "https://github.com/hansec/fortran-language-server.git", branch: "master"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbb19be503ec0e23640180c3ba92887d3f5e9b37e45b2c8e46b9a57c14aa05d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b904b217b0b36b8f5c3112929e4d7b7f296a3e8a8c9ac3de1671cb941181bf55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "231266c09577f03896667b414bf375b8cf399caabebc6c35f102574988758edd"
    sha256 cellar: :any_skip_relocation, sonoma:         "067d39dbc79483550e2c9e06e72883f299e455d1754f95b17052f5cccbf357da"
    sha256 cellar: :any_skip_relocation, ventura:        "e7e2864aed6120a0eb40e68ae452e935c547c0ed004238ce52f830bd4d36e3af"
    sha256 cellar: :any_skip_relocation, monterey:       "ec05c59137add94ac7f4a7d33da5184d303243f88401305739ae6a8871a408bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a7d6a64e177d7cc60bd9c5b933786114fbb0f1a351bb4d7a4a75afe9deb7dbd"
  end

  depends_on "python@3.12"

  conflicts_with "fortls", because: "both install `fortls` binaries"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/fortls --version").strip
    # test file taken from main repository
    (testpath/"test.f90").write <<~EOS
      PROGRAM myprog
      USE test_free, ONLY: scaled_vector
      TYPE(scaled_vector) :: myvec
      CALL myvec%set_scale(scale)
      END PROGRAM myprog
    EOS
    expected_output = <<~EOS
      Testing parser
        File = "#{testpath}/test.f90"
        Detected format: free

      =========
      Parser Output
      =========

      === No PreProc ===

      PROGRAM myprog !!! PROGRAM statement(1)
      USE test_free, ONLY: scaled_vector !!! USE statement(2)
      TYPE(scaled_vector) :: myvec !!! VARIABLE statement(3)
      END PROGRAM myprog !!! END "PROGRAM" scope(5)

      =========
      Object Tree
      =========

      1: myprog
        6: myprog::myvec

      =========
      Exportable Objects
      =========

      1: myprog
    EOS
    test_cmd = "#{bin}/fortls"
    test_cmd << " --debug_parser --debug_diagnostics --debug_symbols"
    test_cmd << " --debug_filepath #{testpath}/test.f90"
    assert_equal expected_output.strip, shell_output(test_cmd).strip
  end
end
