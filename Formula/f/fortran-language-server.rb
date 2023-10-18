class FortranLanguageServer < Formula
  include Language::Python::Virtualenv

  desc "Language Server for Fortran"
  homepage "https://github.com/hansec/fortran-language-server"
  url "https://github.com/hansec/fortran-language-server/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "5cda6341b1d2365cce3d80ba40043346c5dcbd0b35f636bfa57cb34df789ff17"
  license "MIT"
  head "https://github.com/hansec/fortran-language-server.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3679444f613c8f40600ffefadda2051d33a1c1b25d13edc02e354aab9c9b355"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "858ce2ba433f98d3e9c023fc336acc1cc89b90fe7a0ee855644b1ce671ab1e35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "187de99bca47d202ec4c5a387ab9e7904ccd7b1b290b54cca6a57039a6646a16"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad94fb5f1859a9c45dc21f889d108dbca7f2da232c0b13bf12ca7e38350bcbc8"
    sha256 cellar: :any_skip_relocation, ventura:        "7c4fa384cdd6ec3d53d2a6974a9e676bed01695451d455603de38d34480e5bbc"
    sha256 cellar: :any_skip_relocation, monterey:       "69326f21502852d8fdce6a9820e66640e0c1e3ae13557fd9db5ca3ef22a84755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3526e87af11ce092f0b1f4596a87a3f9a2ded9420b7eb6a4f236dd48fdb759aa"
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
