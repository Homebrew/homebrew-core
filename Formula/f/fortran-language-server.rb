class FortranLanguageServer < Formula
  include Language::Python::Virtualenv

  desc "Language Server for Fortran"
  homepage "https://github.com/hansec/fortran-language-server"
  url "https://github.com/hansec/fortran-language-server/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "5cda6341b1d2365cce3d80ba40043346c5dcbd0b35f636bfa57cb34df789ff17"
  license "MIT"
  head "https://github.com/hansec/fortran-language-server.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17c7e96365f45c2bc3f9bd8262cc4817665613c50cb50be547c35284027b3e36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17c7e96365f45c2bc3f9bd8262cc4817665613c50cb50be547c35284027b3e36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17c7e96365f45c2bc3f9bd8262cc4817665613c50cb50be547c35284027b3e36"
    sha256 cellar: :any_skip_relocation, ventura:        "59ed4a2e6b58298c6c0578ba43dffbeeb83e3f0a11287b1e6ca64a98aa9c2260"
    sha256 cellar: :any_skip_relocation, monterey:       "59ed4a2e6b58298c6c0578ba43dffbeeb83e3f0a11287b1e6ca64a98aa9c2260"
    sha256 cellar: :any_skip_relocation, big_sur:        "59ed4a2e6b58298c6c0578ba43dffbeeb83e3f0a11287b1e6ca64a98aa9c2260"
    sha256 cellar: :any_skip_relocation, catalina:       "59ed4a2e6b58298c6c0578ba43dffbeeb83e3f0a11287b1e6ca64a98aa9c2260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5faf0297d9b3999acc76939265cafc7adbe5a2298ba0719f9a0969feb83784fd"
  end

  depends_on "python@3.11"

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
