class FortranLanguageServer < Formula
  include Language::Python::Virtualenv

  desc "Language Server for Fortran"
  homepage "https://github.com/hansec/fortran-language-server"
  url "https://github.com/hansec/fortran-language-server/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "5cda6341b1d2365cce3d80ba40043346c5dcbd0b35f636bfa57cb34df789ff17"
  license "MIT"
  head "https://github.com/hansec/fortran-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b3ef36cf1efbde6f4777037f112161c717629f8be4a58b2208fe82861c58323"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b3ef36cf1efbde6f4777037f112161c717629f8be4a58b2208fe82861c58323"
    sha256 cellar: :any_skip_relocation, monterey:       "32839345a2cdc7894b65d7b6b6a06d439db922a7708973a4fd3e4b3213f6a899"
    sha256 cellar: :any_skip_relocation, big_sur:        "32839345a2cdc7894b65d7b6b6a06d439db922a7708973a4fd3e4b3213f6a899"
    sha256 cellar: :any_skip_relocation, catalina:       "32839345a2cdc7894b65d7b6b6a06d439db922a7708973a4fd3e4b3213f6a899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffd2580a9385f37d0169c8d2e455a413cb9f26c720c269656c4ced9c14bf1365"
  end

  depends_on "python@3.10"

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
