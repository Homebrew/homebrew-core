class FortranLanguageServer < Formula
  include Language::Python::Virtualenv

  desc "Language Server for Fortran"
  homepage "https://github.com/hansec/fortran-language-server"
  url "https://files.pythonhosted.org/packages/72/46/eb2c733e920a33409906aa145bde93b015f7f77c9bb8bdf65faa8c823998/fortran-language-server-1.12.0.tar.gz"
  sha256 "ec3921ef23d7e2b50b9337c9171838ed8c6b09ac6e1e4fa4dd33883474bd4f90"
  license "MIT"
  head "https://github.com/hansec/fortran-language-server.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc6059f065b7349e8ef9a16353b1dc00fd0ad8098b8f17baeaec78282d724d8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "852a215082283f21b6723ec4ad7825da570c65e50a016739ec22ee0258d4e9a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "026fef2556b938306ec1452acd1c3f6cd9eb1e23db80daece43f124fb4b59781"
    sha256 cellar: :any_skip_relocation, sonoma:         "5fe11043b1ae19be5670267c3e85c3a04513ff24be7b804f075def020bc3bb1f"
    sha256 cellar: :any_skip_relocation, ventura:        "8a489566e13d9f57750543b1d57be7b90f4be1e5307c6975a0860d02d94868cb"
    sha256 cellar: :any_skip_relocation, monterey:       "c46faba5b9c41ebdce74d6fbdce64cf8a05c035d0e60d68c8dc684bf6b7cc32c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e62186facb38b3fe9430b8b8890d47364eacba02947b85c41c62e9f707cb6b7"
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
