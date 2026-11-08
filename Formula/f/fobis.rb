class Fobis < Formula
  include Language::Python::Virtualenv

  desc "KISS build tool for automatically building modern Fortran projects"
  homepage "https://github.com/szaghi/FoBiS"
  url "https://files.pythonhosted.org/packages/3f/7a/9f77c75a1102f619a5ee1c48d1941c72583eab06016c2df70fd7b36374dd/fobis_py-3.16.1.tar.gz"
  sha256 "8d8084a049e151dc4f88923232ddba7412df340f9cb112340ba52358c3e9d8f6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4e90dc26fb24d402bbbbba31b21ebcc727dac89a0958bc003828682985e537b3"
  end

  depends_on "gcc" # for gfortran
  depends_on "graphviz"
  depends_on "python@3.15"

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/ad/8f/21021859316f44289101638dc74d82e13d722d8533e4b8708a3ab7c8461a/typer-0.28.0.tar.gz"
    sha256 "69ab84ef79fd601cff071bbd2566d855ecadfd93adbc4b3360b9924359bdd857"
  end

  def install
    virtualenv_install_with_resources
    generate_completions_from_executable(bin/"fobis", shell_parameter_format: :typer)
  end

  test do
    (testpath/"test-mod.f90").write <<~FORTRAN
      module fobis_test_m
        implicit none
        character(*), parameter :: message = "Hello FoBiS"
      end module
    FORTRAN

    (testpath/"test-prog.f90").write <<~FORTRAN
      program fobis_test
        use iso_fortran_env, only: stdout => output_unit
        use fobis_test_m, only: message
        implicit none
        write(stdout,'(A)') message
      end program
    FORTRAN

    system bin/"FoBiS.py", "build", "-compiler", "gnu"
    assert_match "Hello FoBiS", shell_output(testpath/"test-prog")
  end
end
